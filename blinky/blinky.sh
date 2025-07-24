# To use: connect PD4 to the LED

set -xe

R32_GPIOD_CFGLR=0x40011400
R32_GPIOD_BSHR=0x40011410

# enable PD4
wlink write-mem $R32_GPIOD_CFGLR 0x4443b444

while true
do
	# pull low
	wlink write-mem $R32_GPIOD_BSHR $((1<<20))
	sleep 0.5
	# pull high
	wlink write-mem $R32_GPIOD_BSHR $((1<<4))
	sleep 0.5
done
