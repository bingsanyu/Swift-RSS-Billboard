//
//  TableViewController.swift
//  SwiftRSS
//
//  Created by mrguo on 2022/11/22.
//

import UIKit

class ZhihuTableViewController: UITableViewController ,XMLParserDelegate {
        class BlogPost {
            var title = String()
            var description = String()
            var link = String()
            var date = String()
        }
        var parser = XMLParser()
        var blogPosts: [BlogPost] = []
        
        var eName = String()
        var postTitle = String()
        var postLink = String()
        var descriptionText = String()
        var postDate = String()
    
        var listTitle=[String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "zhihuback"), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Light", size: 18)!]
        navigationController?.navigationBar.shadowImage = UIImage()

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        let url = URL(string: "https://rsshub.app/zhihu/hotlist")
        parser = XMLParser(contentsOf: url!)!
        parser.delegate = self
        parser.parse()

        for item in self.blogPosts{
            if (listTitle.firstIndex(of: item.date) == nil) {
                let title=item.date
                listTitle.append(title)
            }
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        eName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let blogPost: BlogPost = BlogPost()
            blogPost.title = postTitle
            blogPost.link = postLink
            blogPost.description = descriptionText
            blogPost.date = postDate
            blogPosts.append(blogPost)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if eName == "title" {
                postTitle = data}
            else if eName == "link" {
                postLink = data
            } else if eName == "description" {
                descriptionText = data
            } else if eName == "pubDate" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd LLL yyyy HH:mm:ss zzz"
                dateFormatter.timeZone = TimeZone(abbreviation: "PDT")
                let formattedDate = dateFormatter.date(from: data)
                if formattedDate != nil {
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    postDate = dateFormatter.string(from: formattedDate!)
                }
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return listTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var s:Int = 0
        for item in blogPosts{
            if item.date==listTitle[section]
            {
                s += 1
            }
        }
        return s
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date=listTitle[section]
        return date
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zhihucell", for: indexPath) as UITableViewCell
        
        let date=listTitle[indexPath.section]
        var s: [BlogPost] = []
        for item in blogPosts{
            if date == item.date{
                s.append(item)
            }
        }
        let currentBlogPost: BlogPost = s[indexPath.row]
        cell.textLabel?.text = currentBlogPost.title

        return cell
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return listTitle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "zhihupost") {
            let webView: WebViewController = segue.destination as! WebViewController
            let section_now = tableView.indexPathForSelectedRow?.section
            var row_now:Int = 0
            if section_now != 0 {
                for i in 0...section_now!-1 {
                    row_now += tableView.numberOfRows(inSection: i)
                }
            }
            webView.blogPostHTML = blogPosts[(tableView.indexPathForSelectedRow?.row)! + row_now].description
            webView.blogPostURL = URL(string:blogPosts[(tableView.indexPathForSelectedRow?.row)! + row_now].link)
        }
    }
}

