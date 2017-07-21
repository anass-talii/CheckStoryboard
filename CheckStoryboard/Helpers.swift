import Foundation

func findFile(rootPath: String, suffix: String) -> [String]? {
    var result = [String]()
    let fm = FileManager.default
    if let paths = fm.subpaths(atPath: rootPath) {
        let storyboardPaths = paths.filter({ return $0.hasSuffix(suffix)})
        for p in storyboardPaths {
            result.append((rootPath as NSString).appendingPathComponent(p))
        }
    }
    return result.count > 0 ? result : nil
}
