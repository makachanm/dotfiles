set -e
src=/usr/share/plymouth/themes
dst=$src/bgrt-nologo
mkdir -p $dst
for f in $src/spinner/*.png; do
  [ "$(basename $f)" = watermark.png ] || cp -f $f $dst/
done
sed -e 's|^ImageDir=.*|ImageDir=/usr/share/plymouth/themes/bgrt-nologo|' -e 's|^Name=BGRT$|Name=BGRT (no logo)|' $src/bgrt/bgrt.plymouth > $dst/bgrt-nologo.plymouth
plymouth-set-default-theme -R bgrt-nologo
