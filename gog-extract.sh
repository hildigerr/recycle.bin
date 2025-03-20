mkdir -p data/noarch
sh "${pkgname}_${pkgver}.sh" --quiet --noexec --target data
export MOJOSETUP_BASE="${srcdir}/${pkgname}_${pkgver}.sh"
echo -e "n\ny\n${srcdir}/data/noarch\n1\n2\n\n" | "${srcdir}/data/bin/linux/x86_64/mojosetup"
