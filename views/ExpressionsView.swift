import SwiftUI


struct ExpressionsView<T: ExpressionProtocol>: View where T: Identifiable {
    @ObservedObject var fi: FNIFIWrapper
    @State private var newExpr: Bool = false
    @State private var expression = T()
    @State private var exprs: [T]
    @State private var path = NavigationPath()
    private var unvalidNewExpression: Bool {
        return expression.expression.isEmpty || expression.name.isEmpty
    }
    
    init(fi: FNIFIWrapper) {
        self.fi = fi
        self.exprs = T.List()
    }
    
    var body: some View {
        if (!newExpr) {
            VStack {
                ForEach(exprs) { expr in
                    let isUsed = expr.isUsed(fi: fi)
                    HStack {
                        Button(action: {
                            expr.use(fi: fi)
                        }) {
                            Text(expr.name)
                        }
                        .disabled(isUsed)
                        Button(action: {
                            expr.delete()
                            exprs = T.List()
                        }) {
                            Image(systemName: "trash")
                        }
                        .disabled(isUsed)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        newExpr = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle(T.className)
        } else {
            List {
                TextField("Expression", text: $expression.expression)
                    .disableAutocorrection(true)
                TextField("Name", text: $expression.name)
                    .disableAutocorrection(true)
            }
            .navigationTitle(T.className)
            .navigationSubtitle("New Expression")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        expression.use(fi: fi)
                        expression.save()
                        exprs = T.List()
                        newExpr = false
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .disabled(unvalidNewExpression)
                }
            }
        }
    }
}
