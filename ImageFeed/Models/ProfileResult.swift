//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 03.04.2025.
//

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
