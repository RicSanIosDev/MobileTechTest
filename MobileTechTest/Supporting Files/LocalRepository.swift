import Foundation

struct LocalKeys {
    static let favorite = "favorite"
    static let favoriteArray = "favoriteArray"
    static let postListCache = "postListCache"
}

class LocalRepository {

    let userDefaults = UserDefaults.standard

    // MARK: - PostFavorite

    func save(post: Post) {
        userDefaults.set(post.data, forKey: LocalKeys.favorite)
    }

    func getPost() -> Post? {
        guard let data = userDefaults.data(forKey: LocalKeys.favorite) else {
            return nil
        }
        return try? JSONDecoder().decode(Post.self, from: data)
    }

    func deletePost() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: LocalKeys.favorite)
    }

    // MARK: - PostListFavorite

    func saveFavoritePost(post: [Post]) {
        userDefaults.set(post.data, forKey: LocalKeys.favoriteArray)
    }

    func getFavoritePostList() -> [Post]? {
        guard let data = userDefaults.data(forKey: LocalKeys.favoriteArray) else {
            return nil
        }
        return try? JSONDecoder().decode([Post].self, from: data)
    }

    func deleteFavoritePostList() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: LocalKeys.favoriteArray)
    }

    // MARK: - PostList

    func savePost(post: [Post]) {
        userDefaults.set(post.data, forKey: LocalKeys.postListCache)
    }

    func getPostList() -> [Post]? {
        guard let data = userDefaults.data(forKey: LocalKeys.postListCache) else {
            return nil
        }
        return try? JSONDecoder().decode([Post].self, from: data)
    }

    func deletePostList() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: LocalKeys.postListCache)
    }
}
