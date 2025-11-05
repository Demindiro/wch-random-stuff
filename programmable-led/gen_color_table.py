#!/usr/bin/env python3

from math import tau as TAU

# Each cycle takes about 1.2µs
# So a wheel that takes roughly 1 second to cycle through has about 1s / 1.2µs elements
STEPS = int(1e6 / (1.2 * (24 + 200)))

# ... to keep the amount of entries reasonable, we'll increase RESET_TICKS such
# that we need only 1000 entries
STEPS = int(1e6 / (1.2 * (24 + 809)))

TAU_6 = TAU / 6

def hsv_to_rgb(h, s, v):
    assert 0 <= h < TAU
    assert 0 <= s <= 1
    assert 0 <= v <= 1
    # https://www.rapidtables.com/convert/color/hsv-to-rgb.html
    c = v * s
    x = c * (1 - abs(((h / TAU_6) % 2) - 1))
    m = v - c
    if h < TAU_6 * 1:
        r, g, b = c, x, 0
    elif h < TAU_6 * 2:
        r, g, b = x, c, 0
    elif h < TAU_6 * 3:
        r, g, b = 0, c, x
    elif h < TAU_6 * 4:
        r, g, b = 0, x, c
    elif h < TAU_6 * 5:
        r, g, b = x, 0, c
    else:
        r, g, b = c, 0, x
    return r + m, g + m, b + m

def encode(r, g, b):
    # RF-W7SA50TS-A51-IC uses G8R8B8, in MSb order
    #
    # for convenience, align to 32 bits so we can use lw
    # and shift between 0-23
    #
    # for MSb order, reverse bits (again: convenience)
    #
    # To even out light consistency, normalize
    #
    # To not get blinded, apply dim factor

    dim = lambda x: x / (r + g + b) * 0.5
    clamp = lambda x: min(max(0, x), 255)

    if 1:
        f = lambda x: clamp(int(dim(x) * 255))
    else:
        rev8 = lambda x: int('{:08b}'.format(x)[::-1], 2)
        f = lambda x: rev8(clamp(int(dim(x) * 255)))
    return f(g) | (f(r) << 8) | (f(b) << 16)

# color wheel: just go from 0 to TAU for H component
def colorwheel(steps):
    if 0:
        for i in range(256):
            yield i/256, 0, 0
        for i in range(256 - 1, -1, -1):
            yield i/256, 0, 0
        return

    if 0:
        for i in range(steps // 3):
            yield hsv_to_rgb(i * TAU / steps + TAU_6*2, 1, 1)
        for i in range(steps // 3 - 1, -1, -1):
            yield hsv_to_rgb(i * TAU / steps + TAU_6*2, 1, 1)
        return 

    for i in range(steps):
        yield hsv_to_rgb(i * TAU / steps, 1, 1)

def encode_asm(x):
    return f'.word 0x{x:08x}'

if __name__ == '__main__':
    n = 0
    for rgb in colorwheel(STEPS):
        x = encode(*rgb)
        print(encode_asm(x), '#', rgb)
        n += 1
    print('.equ COLOR_ENTRIES,', n)
