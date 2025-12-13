protocol ExpressionProtocol: Identifiable {
    static var className: String { get }
    static func List() -> [Self]
    init()
    var name: String { get set }
    var expression: String { get set }
    func isUsed(fi: FNIFIWrapper) -> Bool
    func use(fi: FNIFIWrapper)
    func delete()
    func save()
}
