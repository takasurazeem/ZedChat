//
//  OtherTableView.swift
//  ZedChat
//
//  Created by MacBook Pro on 05/09/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class OtherTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    let arrStatus_General = [
    "Available",
    "Busy",
    "Sleeping",
    "Urgent calls only",
    "Can't talk, \(APPBUILDNAME ?? "") only",
    "Good morning. Let the stress begin",
    "Eat… Sleep… Regret… Repeat",
    "move on…",
    "\(APPBUILDNAME ?? "") status is loading…",
    "I may be wrong… but I doubt it !",
    "Too busy to update a status. 0_o",
    "battery about to die",
    "Waiting for wi-fi network",
    "Status under construction",
    "Hey there… be there",
    "Without me its just awso"]
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Status"
        self.tablev.register(UINib(nibName: "StatusCell", bundle: nil), forCellReuseIdentifier: "StatusCell")
        self.tablev.tableFooterView = UIView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(funback))
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(profileupdate), name: NSNotification.Name(rawValue: "profileupdate"), object: nil)
    }
    @objc func funback()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func profileupdate(){
        funback()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStatus_General.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "StatusCell") as! StatusCell
        cell.lbltitle.text = arrStatus_General[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IPAD{
            return 80
        }
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        funprofileupdate(type: "status", text: arrStatus_General[indexPath.row], andicator: andicator, viewController: self)
    }
}


//<string-array name="general_status">
//<item>Available</item>
//<item>Busy</item>
//<item>Sleeping</item>
//<item>Urgent calls only</item>
//<item>Good morning. Let the stress begin</item>
//<item>Eat… Sleep… Regret… Repeat</item>
//<item>move on…</item>
//<item>Zed Chat status is loading…</item>
//<item>I may be wrong… but I doubt it !</item>
//<item>Too busy to update a status. 0_o</item>
//<item>battery about to die</item>
//<item>Waiting for wi-fi network</item>
//<item>Status under construction</item>
//<item>Hey there… be there</item>
//<item>Without me its just awso</item>
//</string-array>
//
//<string-array name="love_status">
//<item>Why do I need a date for Valentine’s Day? I can buy my own damn flowers &amp; box of chocolate…</item>
//<item>Love is the whole history of a woman’s life, it is but an episode in a man’s</item>
//<item>Happiness is when “Last seen at” changes to “online” and then to “typing..”</item>
//<item>My “last seen at” was just to check your “last seen at”</item>
//<item>I wish i could trade my heart for another liver …..so that i can drink more and care less</item>
//<item>Even romeo went from being “in a relationship” to “it’s complicated”</item>
//<item>One day you will someone who will not care about your past b’cos they want to be your future</item>
//<item>True love doesn’t have happy ending… it has No ending</item>
//<item>Love isn’t complicated… People are</item>
//<item>Love doesn’t need to be perfect.It needs to be true</item>
//<item>Come in my Heart and pay no rent</item>
//<item>Love is beautiful mistake of my life</item>
//<item>I don’t fear to lose her, But my fear is that if i loose “Who will love her like me?”</item>
//<item>Everyone says you fall in love only ones, but i fall daily with the same person</item>
//</string-array>
//
//<string-array name="funny_status">
//<item>Stop checking my status ! Go Get A Life.)</item>
//<item>I can see you checking my whatsapp status. B)</item>
//<item>If you try to pronounce “lmao” you sound like a french cat</item>
//<item>My laziness is like 8, when I lie down it becomes infinity</item>
//<item>Keep moving! Nothing new to read</item>
//<item>Me and my wife lived happily for 25 years… And then we met…!</item>
//<item>One more password got married…!</item>
//<item>One person’s LOL is another’s WTF!</item>
//<item>I have enough money to live comfortably for the rest of my life… if I die next Tuesday</item>
//<item>A man in love is not complete until he is married…… Then he is finished</item>
//</string-array>
//
//<string-array name="cool_status">
//<item>Don’t be too optimistic. The light at the end of the tunnel may be another train</item>
//<item>People are like music some say the truth and rest, just noise</item>
//<item>It’s not how tragically we suffer but how miraculously we live</item>
//<item>Always remember you’re UNIQUE… just like everybody else</item>
//<item>You don’t have to like me… I am not a facebook status</item>
//<item>Everything that kills me makes me feel alive</item>
//<item>It’s so simple to be wise Just think of something stupid to say and then don’t say it</item>
//<item>Tried to lose weight… But it keeps finding me</item>
//<item>This is the beginning of the sentence you just finished reading</item>
//<item>I Am Not Special, I Am Just Limited Edition</item>
//<item>Sleep till you’re hungry… Eat till you’re sleepy</item>
//<item>Smile today, tomorrow could be worse</item>
//<item>Why is Monday so far from Friday and Friday so near to monday?</item>
//<item>Take Life, one cup at a time!</item>
//<item>Exams!!! The most creative phase of life 🙂</item>
//<item>One day, I’m gonna make the onions cry</item>
//<item>I’m cool but global warming made me hot</item>
//<item>Dear Math, please grow up and solve your own problems, I’m tired of solving them for you</item>
//<item>We live in a society were pizza gets to your house before police</item>
//<item>God is really creative , i mean… just look at me</item>
//<item>I started out with nothing and i still have most of it</item>
//<item>I enjoy when people show Attitude to me because it shows that they need an Attitude to impress me!
//<item>When i am good i am best , when i am bad i am worst</item>
//<item>The bad news is time flies</item>The good news is you are pilot</item>
//<item>Every day may not be good but there is something good in every day</item>
//<item>Life is not a matter of milestones but of moments</item>
//</string-array>
//
//<string-array name="good_status">
//<item>Life is too short. Don’t waste it reading my watsapp status</item>
//<item>Formula for success… under promise and over deliver</item>
//<item>Don’t settle for good. Demand Great</item>
//<item>Life is the art of drawing without an eraser</item>
//<item>Hakuna Matata!!–the great motto to live life!!</item>
//<item>Sometimes i just wish i’ could fast forward the time to see if in the end it’s all worth it</item>
//<item>We are all part of the ultimate statistic – ten out of ten die</item>
//<item>Dream as if you’ll live forever..Live as if tomorrow is last one</item>
//<item>The only difference between a good day and a bad day is your attitude</item>
//<item>Life is like ice cream, enjoy it before it melts</item>
//<item>Just about the time when you think you can make ends meet, somebody moves the ends</item>
//<item>I’ll try being nicer if you start being smarter</item>
//<item>I haven’t slept for 10 days, because that would be too long</item>
//<item>Life was much easier when Apple and Blackberry were just fruits</item>
//<item>Life is like photography, you use the negatives to develop</item>
//<item>Stop waiting for one Day. Today is the Day- Bang-Bang</item>
//<item>If people are trying to bring you ‘Down’, It only means that you are ‘Above them’</item>
//<item>Knowledge is knowing tomato is a fruit… wisdom is not putting it in a fruit salad</item>
//<item>Everything happens for a reason</item>
//<item>Life is too short to imitate somebody</item>
//</string-array>
