for pkg in $(pacman -Qqm); do
  if readelf -d $(pacman -Qql $pkg) 2>/dev/null | grep NEEDED | grep -q libstdc++.so; then
    echo $pkg
  fi
done
