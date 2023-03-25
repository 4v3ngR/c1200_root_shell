#!/bin/sh

# work out where we are mounted
MNT=$(readlink -f $0 | sed -e 's/\/www.*//g' -e 's/\/files.*//g')

[ -d "$MNT/www" ] || {
  echo "Bootstrapping the web interface"
  cp -r /www "$MNT/www" 2> /dev/null
  cp "$MNT/files/root.sh" "$MNT/www/cgi-bin/root.sh"

  echo "Bootstrap complete"
	echo ""
	echo "Next steps:"
	echo "  1. edit configuration backup"
	echo "      - change uhttpd->home from '/www' to '$MNT/www'"
	echo "  2. restore the C1200's configuration"
	echo "  3. wait for the reboot"
  echo ""
  echo "To enable root access:"
	echo "  load http://router_addr/cgi-bin/root.sh"
	echo ""
  echo "This needs to be done after each router reboot"
}
