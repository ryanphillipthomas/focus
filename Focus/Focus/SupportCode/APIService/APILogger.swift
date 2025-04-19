import Foundation
import Alamofire
import FirebaseCrashlytics

class APILogger: EventMonitor {
    let queue = DispatchQueue(label: "com.focus.apiLogger")

    // MARK: - Request Lifecycle

    func requestDidResume(_ request: Request) {
        let url = request.request?.url?.absoluteString ?? "unknown URL"
        let method = request.request?.httpMethod ?? "UNKNOWN"
        log("Request Started: [\(method)] \(url)")
    }

    func requestDidFinish(_ request: Request) {
        guard let req = request.request,
              let url = req.url?.absoluteString,
              let response = request.response else { return }

        let statusCode = response.statusCode
        let duration = request.metrics?.taskInterval.duration ?? 0
        log("Request Finished: \(url) [Status: \(statusCode), Duration: \(String(format: "%.2fs", duration))]")
    }

    func request(_ request: DataRequest, didFailWithError error: Error) {
        let url = request.request?.url?.absoluteString ?? "unknown URL"
        let statusCode = request.response?.statusCode ?? -1
        let duration = request.metrics?.taskInterval.duration ?? 0
        log("Request Failed: \(url) [Status: \(statusCode), Duration: \(String(format: "%.2fs", duration))] - \(error.localizedDescription)")
        Crashlytics.crashlytics().record(error: error)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let url = request.request?.url?.absoluteString ?? "unknown URL"
        let statusCode = request.response?.statusCode ?? -1
        let duration = request.metrics?.taskInterval.duration ?? 0

        switch response.result {
        case .success:
            log("Response Success: \(url) [Status: \(statusCode), Duration: \(String(format: "%.2fs", duration))]")
        case .failure(let error):
            log("Response Failed: \(url) [Status: \(statusCode), Duration: \(String(format: "%.2fs", duration))] - \(error.localizedDescription)")
        }
    }


    // MARK: - Shared Logging Utility

    static func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
        InAppLogStore.shared.append(message, for: "API", type: .api)
        Crashlytics.crashlytics().log(message)
    }

    private func log(_ message: String) {
        Self.log(message)
    }
}
