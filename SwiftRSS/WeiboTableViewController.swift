//
//  TableViewController.swift
//  SwiftRSS
//
//  Created by mrguo on 2022/11/22.
//

import UIKit

class WeiboTableViewController: UITableViewController ,XMLParserDelegate {
        class BlogPost {
            var title = String()
            var link = String()
        }
        var parser = XMLParser()
        var blogPosts: [BlogPost] = []
        
        var eName = String()
        var postTitle = String()
        var postLink = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "weiboback"), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Light", size: 18)!]
        navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        let url = URL(string: "http://rsshub.app/weibo/search/hot")
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
            blogPosts.append(blogPost)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if eName == "title" {
                postTitle = data
            } else if eName == "link" {
                postLink = data
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "weibocell", for: indexPath) as UITableViewCell
        let currentBlogPost: BlogPost = blogPosts[indexPath.row]
        cell.textLabel?.text = currentBlogPost.title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "weibopost") {
            let webView: WebViewController = segue.destination as! WebViewController
            webView.blogPostURL = URL(string:blogPosts[(tableView.indexPathForSelectedRow?.row)!].link)
        }
    }
}

