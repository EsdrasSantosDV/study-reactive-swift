import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Cadastro")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)
                .padding(.bottom, 20)
            
            // Nome
            TextField("Nome Completo", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(viewModel.nameValid ? Color.clear : Color.red.opacity(0.3))
                .cornerRadius(8)
            
            // E-mail
            TextField("E-mail", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
                .background(viewModel.emailValid ? Color.clear : Color.red.opacity(0.3))
                .cornerRadius(8)
            
            // Senha
            SecureField("Senha", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(viewModel.passwordValid ? Color.clear : Color.red.opacity(0.3))
                .cornerRadius(8)
            
            // Gênero
            Picker("Gênero", selection: $viewModel.gender) {
                ForEach(ContentViewModel.Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            
            Button(action: viewModel.submit) {
                Text("Enviar")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.formValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.formValid)
            .padding(.top, 20)
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(15)
        .padding()
        .shadow(radius: 10)
    }
}

#Preview {
    ContentView()
}

class ContentViewModel: ObservableObject {
    enum Gender: String, CaseIterable {
        case male = "Masculino"
        case female = "Feminino"
        case other = "Outro"
    }

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var gender: Gender = .male
    
    @Published var nameValid: Bool = true
    @Published var emailValid: Bool = true
    @Published var passwordValid: Bool = true
    @Published var formValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $name
            .map { !$0.isEmpty }
            .assign(to: &$nameValid)
        
        $email
            .map { self.isValidEmail($0) }
            .assign(to: &$emailValid)
        
        $password
            .map { $0.count >= 8 }
            .assign(to: &$passwordValid)
        
    
        Publishers.CombineLatest3($nameValid, $emailValid, $passwordValid)
            .map { $0 && $1 && $2 }
            .assign(to: &$formValid)
        
    }
    
    func submit() {
        // Lógica para envio do formulário
        print("Formulário enviado!")
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
}
