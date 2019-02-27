//
//  ChatView.swift
//  UCLA Radio
//
//  Created by Joseph Clegg on 1/27/19.
//  Copyright © 2019 UCLA Student Media. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

class ChatView: UIView, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    var chatBox: UITextView!
    
    var sendButton: UIButton!
    
    var tableView: UITableView!
    
    var messagesArray: [ChatBubbleData]!
    
    var socketClient: SocketIOClient!
    
    var manager:SocketManager!
    var socket:SocketIOClient!
    
    var username: String = "DEFAULT"
    
    var lastID: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Constants.Colors.darkBackground
        
        messagesArray = [ChatBubbleData]()
        
        
        //declare our various views to be used in this view controller
        chatBox = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.width*3/5, height: 20))
        chatBox.text = "Write a message"
        chatBox.textColor = UIColor.lightGray
        chatBox.delegate = self
        chatBox.backgroundColor = UIColor.clear
        chatBox.font = UIFont(name: (chatBox.font?.fontName)!, size: 20)
        
        sendButton = UIButton(type: .roundedRect)
        sendButton.setTitle("Send", for: UIControlState.normal)
        sendButton.titleLabel?.font = UIFont(name: (sendButton.titleLabel?.font.fontName)!, size: 20)
        sendButton.sizeToFit()
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height*4/5))
        self.tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        //This line flips the y-axis of our table view, basically flipping it upside down.
        //We do this because it allows us to have chat bubbles appear from the bottom up, not up to bottom.
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        addSubview(chatBox)
        addSubview(tableView)
        addSubview(sendButton)
        
        chatBox.translatesAutoresizingMaskIntoConstraints = false;
        sendButton.translatesAutoresizingMaskIntoConstraints = false;
        //tableView.translatesAutoresizingMaskIntoConstraints = false;

        
        //socketIO stuff.  First we create a manager object for our connection
        //then we add event handlers to handle events such as assign username
        //and new messages, then we connect to the server
        self.manager = SocketManager(socketURL: URL(string: "https://uclaradio.com")!, config: [.log(true),.compress])
        self.socket = manager.defaultSocket
        self.addHandlers()
        self.socket.connect()
        addConstraints(preferredConstraints())
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func sendButtonAction(sender: UIButton!) {
        
        //print("button pressed!!")
        //self.socket.emit("add user")
        if(self.username != "DEFAULT" && chatBox.text != ""){
            let messageText: String = chatBox.text
            let currentTime: String = getCurrentTime()
            let newMessage: ChatBubbleData = ChatBubbleData(message: messageText, username: self.username, time: currentTime, user: true)
        
            let jsonMessage: [String: Any] = [
                "user": username,
                "text": messageText
            ]
            
            self.socket.emit("new message", jsonMessage)
            
            //pushBubble(bubble: newMessage)
            chatBox.text = ""
        }
        
    }
    
    
    //TextViewDelegate functions, they essentially handle the placeholder text in our chat box
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a message"
            textView.textColor = UIColor.lightGray
            textView.resignFirstResponder()
        }
    }
    
    //TableViewDelegate functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(messagesArray[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! ChatBubbleCell
        
        cell.backgroundColor = UIColor.clear
        
        
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        cell.textLabel?.text = messagesArray[indexPath.row].message
        
        if(messagesArray[indexPath.row].user){
            cell.textLabel?.textColor = UIColor.white
            cell.bubbleColor = Constants.Colors.reallyDarkBlue
            cell.isRight = true
        } else {
            cell.textLabel?.textColor = UIColor.black
            cell.bubbleColor = UIColor.white
        }
        
        //let width = self.frame.width
        
        
        cell.detailTextLabel?.text = messagesArray[indexPath.row].userName + " " + getCurrentTime()
        cell.detailTextLabel?.textColor = UIColor.yellow
//        cell.addSubview(messagesArray[indexPath.row])
//        cell.backgroundColor = UIColor.clear
//        cell.sizeToFit()
//        cell.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 100)
        
        //important!  This line forces the chat bubble to redraw itself.  Important when we're recycling view like we are here, because otherwise we might try to use the bubble from a previous message
        
        
        cell.setNeedsDisplay();
        return cell
    }
    
    
    
    func preferredConstraints() -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        //specify the metrics for our layout
        let metrics = ["button": sendButton]
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[table]-[chatBox]-100-|", options: [], metrics: metrics, views: ["table": self.tableView, "chatBox": chatBox])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chatBox]-[sendButton]-|", options: [], metrics: metrics, views: ["chatBox": chatBox, "sendButton": sendButton])
        
        constraints.append(NSLayoutConstraint(item: sendButton, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        constraints.append(NSLayoutConstraint(item: chatBox, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1.0, constant: 1.0))
        constraints.append(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 1.0))
        constraints.append(NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 1.0))
        
        return constraints
    }
    
    func pushBubble(bubble: ChatBubbleData){
        //messagesArray.append(bubble)
        //print("mark mark mark two")
        tableView.beginUpdates()
        
        //tableView.beginUpdates()
        messagesArray.insert(bubble, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        //shouldAnimateFirstRow = true
        //tableView.endUpdates()
        
        tableView.endUpdates()
    }
    
    func getCurrentTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let currentTime = String(hour!) + ":" + String(minute!) + ":" + String(second!)
        
        return currentTime
    }
    
    func addHandlers(){
        
        self.socket.on("assign username") {[weak self] data, ack in self?.addHandlers()
            self?.username = data[0] as! String
        }
        
        self.socket.on(clientEvent: .connect) {data, ack in
            self.socket.emit("add user")
        }
        
        self.socket.on("new message") {[weak self] data, ack in self?.addHandlers()
            
            guard let jsonArray = data as? [[String: Any]] else {
                return
            }
            
            let uid: Int = jsonArray[0]["id"] as! Int
            let userName: String = jsonArray[0]["user"] as! String
            let textMsg: String = jsonArray[0]["text"] as! String

            var isUser: Bool = false
            
            
            
            if(userName == self?.username){
                isUser = true
            }
            
            if(self?.lastID != uid){
                let newMessage: ChatBubbleData = ChatBubbleData(message: textMsg, username: userName, time: (self!.getCurrentTime()), user: isUser)
            
                self?.pushBubble(bubble: newMessage)
                self?.lastID = uid
            }
        }
        
    }
    
    
    
}
