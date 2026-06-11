class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://app-registro-att-api.onrender.com',
  );

  static const String atividadesEndpoint = '$baseUrl/api/atividades';
}
