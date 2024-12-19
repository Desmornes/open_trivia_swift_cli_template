// Langage de programmation Swift
// https://docs.swift.org/swift-book

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Dispatch

print("Bienvenue au quiz Trivia")
struct questionQuiz: Codable {
    var categorie: String
    var niveau: String
    var question: String
    var correcte: String
    var incorrecte: [String]

    enum CodingKeys: String, CodingKey {
        case categorie = "category" 
        case niveau = "difficulty" 
        case question = "question"         
        case correcte = "correct_answer" 
        case incorrecte = "incorrect_answers" 
    }
}
let url = URL(string: "https://opentdb.com/api.php?amount=10")!
func afficherQuestions(questions: [questionQuiz]) {
    var score = 0
    for question in questions {
        print("Catégorie : \(question.categorie)")
        print("Niveau : \(question.niveau)")
        print("Question : \(question.question)")

         var toutesReponses = question.incorrecte
        toutesReponses.append(question.correcte)
        toutesReponses.shuffle() 
  
        for (i, reponse) in toutesReponses.enumerated() {
            print("\(i + 1). \(reponse)")
        }
        var reponseUtilisateur: String?
        repeat {
            print("Choisissez votre réponse : ", terminator: "")
            reponseUtilisateur = readLine()

           if let reponse = reponseUtilisateur, let rep = Int(reponse), rep >= 1 && rep <= toutesReponses.count {
                let reponseChoisie = toutesReponses[rep - 1]
                if reponseChoisie == question.correcte {
                    print("Bonne réponse, félicitations! ")
                     score += 1
                } else {
                     print("Mauvaise réponse. La bonne réponse est : \(question.correcte).")
                }
            } 
    print("**** Fin du Quiz ****")
    print("Votre score final est: \(score) / \(questions.count)")
        } while reponseUtilisateur == nil
    }
}
struct ReponseAPIQuiz: Codable {
    var codeReponse: Int
    var resultats: [questionQuiz]

    enum CodingKeys: String, CodingKey {
        case codeReponse = "response_code" 
        case resultats = "results"  
    }
}
func recupererQuestions() {
    let tache = URLSession.shared.dataTask(with: url) { donnees, reponse, erreur in
        if let erreur = erreur {
            print("Erreur lors de l'appel API : \(erreur.localizedDescription)")
            exit(EXIT_FAILURE)
        }
        if let donnees = donnees {
           do {               
                let donneesDecodees = try JSONDecoder().decode(ReponseAPIQuiz.self, from: donnees)                              
                if !donneesDecodees.resultats.isEmpty {                 
                    afficherQuestions(questions: donneesDecodees.resultats)
                    exit(EXIT_SUCCESS)
                } else {
                    print("Aucune question trouvée.")
                    exit(EXIT_FAILURE)
                }
            } catch {
                print("Erreur: \(error.localizedDescription)")
                exit(EXIT_FAILURE)
            }
        }
    }
    tache.resume()
}
DispatchQueue.main.async {
    recupererQuestions()
}
dispatchMain()
