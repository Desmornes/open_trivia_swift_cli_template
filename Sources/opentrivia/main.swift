// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Dispatch

print("Open Trivia")
let url = URL(string: "https://opentdb.com/api.php?amount=10")!

// Fonction pour récupérer les données depuis l'API
func fetchTriviaQuestions() {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Erreur lors de l'appel API : \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        }

        if let data = data {
            // Afficher les données brutes pour vérifier
            print("Données reçues :")
            print(String(data: data, encoding: .utf8) ?? "Impossible d'afficher les données")
            
            // Appel terminé
            exit(EXIT_SUCCESS)
        }
    }
    task.resume() // On lance la requête
}
DispatchQueue.main.async {
    fetchTriviaQuestions()
}

dispatchMain()
