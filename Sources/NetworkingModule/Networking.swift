import Foundation

public protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(urlString: String, completion: @escaping @Sendable (Result<T, NetworkService.NetworkError>) -> Void)
}

public class NetworkService: NetworkServiceProtocol {
    
    public init() {}
    
    public enum NetworkError: Error {
        case invalidURL
        case noData
        case invalidResponse
        case statusCodeError(Int)
        case decodingError(String)
        case unknown(Error)
    }

    public func fetchData<T: Decodable>(urlString: String,headers: [String: String] = [:], completion: @escaping @Sendable (Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.statusCodeError(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { 
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }.resume()
    }
}
