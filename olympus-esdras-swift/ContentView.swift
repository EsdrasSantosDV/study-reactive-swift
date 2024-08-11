import SwiftUI
import Combine

struct ContentView: View {
   
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            TextField("Digite algo...", text: $viewModel.inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text(viewModel.outputText)
                .padding()
            Text("Esdras Khan")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


class ContentViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var outputText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $inputText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { "Você digitou: \($0)" }
            .assign(to: \.outputText, on: self)
            .store(in: &cancellables)
    }
}
