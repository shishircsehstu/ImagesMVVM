import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private var isConnected: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    /// ✅ Synchronous function that instantly checks internet status
    func isInternetAvailable() -> Bool {
        let path = NWPathMonitor().currentPath
        return path.status == .satisfied
    }
}
