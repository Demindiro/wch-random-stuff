(use-modules
  (gnu packages embedded)
  (gnu packages cross-base))

(define xbinutils-rv32ec
  (let ((triplet "riscv32-none-elf"))
	(cross-binutils triplet)))

xbinutils-rv32ec
