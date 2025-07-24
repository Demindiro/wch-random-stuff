(use-modules
  (gnu packages embedded)
  (gnu packages cross-base))

(define xgcc-rv32ec
  (let ((triplet "riscv32-none-elf"))
	(cross-gcc triplet
	  #:xbinutils (cross-binutils triplet))))

xgcc-rv32ec
