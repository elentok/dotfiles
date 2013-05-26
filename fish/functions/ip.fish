function ip -d 'shows current ip addresses'
  ifconfig | grep 'inet ' | awk '{print $2}'
end
