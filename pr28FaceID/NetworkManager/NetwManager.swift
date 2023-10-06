//
//  NetwManager.swift
//  pr28FaceID
//
//  Created by Никита Попов on 5.10.23.
//

import Foundation

struct FetchData{
    
    func fetchData(limit: Int, result: @escaping ((ResultJoke)->(Void))){
        guard let url = URL(string: "https://api.api-ninjas.com/v1/jokes?limit=\(limit)") else { return }
        var req = URLRequest(url: url)
        req.setValue("0VxVJ2Po57lg1t+nw6rhwQ==P9dWJ6V5IqOeI1Na", forHTTPHeaderField: "X-Api-Key")
        let _ = URLSession.shared.dataTask(with: req) { data, resp, err in
            guard err == nil else { return }
            guard let data = data else { return }
            if let res = parseData(data: data){
                result(res)
            }
            
        }.resume()
    }
    
    private func parseData(data: Data) -> ResultJoke? {
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode([BaseJoke].self, from: data) else { return nil }
        let resJoke = ResultJoke(item: result.first)
        return resJoke
    }
    
}

