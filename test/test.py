import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_bpsk_qpsk(dut):
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())
    await ClockCycles(dut.clk, 2)

    assert int(dut.uo_out.value) == 0, "Reset failed"

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    for mode in (0, 1):
        for data in range(4):
            # ui_in[3] = valid, ui_in[2] = mode,
            # ui_in[1:0] = data
            dut.ui_in.value = 8 | (mode << 2) | data

            await ClockCycles(dut.clk, 2)

            expected_i = 1 - ((data >> 1) & 1)
            expected_q = (1 - (data & 1)) if mode else 0
            expected = 4 | (expected_q << 1) | expected_i

            actual = int(dut.uo_out.value)
            assert actual == expected, (
                f"mode={mode}, data={data}: "
                f"expected={expected}, actual={actual}"
            )

    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 2)

    assert (int(dut.uo_out.value) & 4) == 0, "valid_out failed"
    assert int(dut.uio_out.value) == 0, "uio_out failed"
    assert int(dut.uio_oe.value) == 0, "uio_oe failed"

    dut._log.info("ALL BPSK/QPSK TESTS PASSED")
