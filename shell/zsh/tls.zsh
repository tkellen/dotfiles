certcheck () {
  echo | openssl s_client -servername NAME -connect $1:443 2>/dev/null | openssl x509 -noout -dates
}
