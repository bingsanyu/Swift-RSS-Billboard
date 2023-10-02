//
//  TableViewController.swift
//  SwiftRSS
//
//  Created by mrguo on 2022/11/22.
//

import UIKit




class BiliTableViewController: UITableViewController ,XMLParserDelegate {
        class BlogPost {
            var title = String()
            var link = String()
            var author = String()
            var imageurl: URL? = nil
        }
        var parser = XMLParser()
        var blogPosts: [BlogPost] = []
        
        var eName = String()
        var postTitle = String()
        var postLink = String()
        var postAuthor = String()
        var postImageurl: URL? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "biliback"), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Light", size: 18)!]
        navigationController?.navigationBar.shadowImage = UIImage()

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        let url = URL(string: "https://rsshub.app/bilibili/ranking/0/3/1")
        parser = XMLParser(contentsOf: url!)!
        parser.delegate = self
        parser.parse()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            eName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let blogPost: BlogPost = BlogPost()
            blogPost.title = postTitle
            blogPost.link = postLink
            blogPost.author = postAuthor
            blogPost.imageurl = postImageurl
            blogPosts.append(blogPost)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if eName == "title" {
                postTitle = data.separating(every: 15, separator: "\n")+"\n"
            } else if eName == "link" {
                postLink = data
            } else if eName == "author" {
                postAuthor = "up主：" + data
            } else if eName == "description" {
                let regex = "(http[^\\s]+(jpg|jpeg|png|tiff)\\b)"
                // 截取所有img url
                let resultItems = data.matchesForRegex(regex: regex)
                if resultItems != [] {
//                    let url = URL(string: resultItems![0] + "@100w.jpg")
                    let url = URL(string: resultItems![0])
                    postImageurl = url
                }
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bilicell", for: indexPath) as UITableViewCell
        let currentBlogPost: BlogPost = blogPosts[indexPath.row]
        cell.textLabel?.text = currentBlogPost.title
        cell.detailTextLabel?.text = currentBlogPost.author
        

        cell.textLabel?.numberOfLines = 2
        cell.detailTextLabel?.numberOfLines = 1

        let bilimask = cell.viewWithTag(114) as! UIImageView
        bilimask.image = UIImage(data: NSData(contentsOf: currentBlogPost.imageurl!)! as Data)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "bilipost") {
            let webView: WebViewController = segue.destination as! WebViewController
            webView.blogPostURL = URL(string:blogPosts[(tableView.indexPathForSelectedRow?.row)!].link)
        }
    }
}

extension String {

    /**
     根据 正则表达式 截取字符串
     
     - parameter regex: 正则表达式
     
     - returns: 字符串数组
     */
    public func matchesForRegex(regex: String) -> [String]? {
        
        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: [])
            let range = NSMakeRange(0, self.count)
            let results = regularExpression.matches(in: self, options: [], range: range)
            let string = self as NSString
            return results.map { string.substring(with: $0.range)}
        } catch {
            return nil
        }
    }
}

extension String {
    func separating(every: Int, separator: String) -> String {
        let regex = #"(.{\#(every)})(?=.)"#
        return self.replacingOccurrences(of: regex, with: "$1\(separator)", options: [.regularExpression])
    }
}

