String _formatPem(String pem, String beginToken, String endToken) {
  pem = pem.replaceAll(beginToken, '').replaceAll(endToken, '');
  pem = pem.replaceAll(
    RegExp(r'\s+'),
    '',
  ); // Supprime tous les espaces
  pem = pem.replaceAllMapped(
    RegExp(r'.{1,64}'),
    (match) => '${match.group(0)}\n',
  ); // Ajoute des retours à la ligne toutes les 64 caractères
  return '$beginToken\n$pem$endToken';
}

String formatPublicPem(String pem) {
  return _formatPem(
      pem, '-----BEGIN PUBLIC KEY-----', '-----END PUBLIC KEY-----');
}

String formatPrivatePem(String pem) {
  return _formatPem(
      pem, '-----BEGIN PRIVATE KEY-----', '-----END PRIVATE KEY-----');
}

