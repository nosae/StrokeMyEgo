//
//  ViewController.swift
//  Stroke My Ego
//
//  Created by Nosakhare Edogun on 12/10/21.
//

import GoogleMobileAds
import UIKit
import SQLite3

import AVFoundation

let mainmenu = mainMenu()

let userName = mainmenu.nameInField()

let sb = UIStoryboard(name: "Main", bundle: nil)
let myVC = sb.instantiateViewController(withIdentifier: "mainmenu") as? mainMenu

// Configure the view controller.
let synthesizer = AVSpeechSynthesizer()

var QuoteArray: [String] = []

let appDelegate = UIApplication.shared.delegate as! AppDelegate


class ViewController: UIViewController, GADBannerViewDelegate {
    
    let stateStatus = UserDefaults.standard.string(forKey: "State") ?? "On"
    
    let cellReuseIdentifier = "cell"
        
    var db: OpaquePointer?
    
    var timer = Timer()
    
    var utterance = AVSpeechUtterance(string: "")
    
    @IBOutlet var bannerView: GADBannerView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var backButton: UIButton!

    @IBAction func info_button(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Information", message: "This app was created to remind you that you are amazing. Don't wait for someone else to do it... \n STROKE YOUR OWN EGO.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
        
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    @IBOutlet weak var rub_image: UIImageView!
    
    @IBOutlet weak var speechText: UILabel!
    
    var rotateMe: UIRotationGestureRecognizer?
    
    private var strokeCount: Int = 0
    
    static var gestureDidFireTimer: Timer? = nil
    
    let corgiView = UIImageView.init(image: UIImage.init(named: "corgi_still"))
    
    let corgiGif = UIImage.gif(name: "corgi")
    
    let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)

     // Create the actions
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
         UIAlertAction in
         NSLog("OK Pressed")
     }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
         UIAlertAction in
         NSLog("Cancel Pressed")
     }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        addBannerViewToView(bannerView)
        
        //main banner
        bannerView.adUnitID = "ca-app-pub-1756782116442486/2488412098"
          
//        //test banner
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
        
        let userName = mainmenu.nameInField()
        
        QuoteArray = [
            "\(userName) you're an awesome friend.",
            "\(userName) you're a gift to those around you.",
            "\(userName) you're a smart cookie.",
            "\(userName) you are awesome!",
            "\(userName) you have impeccable manners.",
            "\(userName) i like your style.",
            "\(userName) you have the best laugh.",
            "\(userName) i appreciate you.",
            "\(userName) you are the most perfect you there is.",
            "\(userName) you are enough.",
            "\(userName) you're strong.",
            "\(userName) your perspective is refreshing.",
            "\(userName) i'm grateful to know you.",
            "\(userName) you light up the room.",
            "\(userName) you deserve a hug right now.",
            "\(userName) you should be proud of yourself.",
            "\(userName) you're more helpful than you realize.",
            "\(userName) you have a great sense of humor.",
            "\(userName) you've got an awesome sense of humor!",
            "\(userName) you are really courageous.",
            "\(userName) your kindness is a balm to all who encounter it.",
            "\(userName) you're all that and a super-size bag of chips.",
            "\(userName) on a scale from 1 to 10, you're an 11.",
            "\(userName) you are strong.",
            "\(userName) you're even more beautiful on the inside than you are on the outside.",
            "\(userName) you have the courage of your convictions.",
            "\(userName) i'm inspired by you.",
            "\(userName) you're like a ray of sunshine on a really dreary day.",
            "\(userName) you are making a difference.",
            "\(userName) thank you for being there for me.",
            "\(userName) you bring out the best in other people.",
            "\(userName) your ability to recall random factoids at just the right time is impressive.",
            "\(userName) you're a great listener.",
            "\(userName) how is it that you always look great, even in sweatpants?",
            "\(userName) everything would be better if more people were like you!",
            "\(userName) i bet you sweat glitter.",
            "\(userName) you were cool way before hipsters were cool.",
            "\(userName) that color is perfect on you.",
            "\(userName) hanging out with you is always a blast.",
            "\(userName) you always know and say exactly what i need to hear when i need to hear it.",
            "\(userName) you help me feel more joy in life.",
            "\(userName) you may dance like no one's watching, but everyone's watching because you're an amazing dancer!",
            "\(userName) being around you makes everything better!",
            "\(userName) when you're not afraid to be yourself is when you're most incredible.",
            "\(userName) colors seem brighter when you're around.",
            "\(userName) you're more fun than a ball pit filled with candy. (and seriously, what could be more fun than that?)",
            "\(userName) that thing you don't like about yourself is what makes you so interesting.",
            "\(userName) you're wonderful.",
            "\(userName) you have cute elbows. for reals!",
            "\(userName) jokes are funnier when you tell them.",
            "\(userName) you're better than a triple-scoop ice cream cone. with sprinkles.",
            "\(userName) when i'm down you always say something encouraging to help me feel better.",
            "\(userName) you are really kind to people around you.",
            "\(userName) you're one of a kind!",
            "\(userName) you help me be the best version of myself.",
            "\(userName) if you were a box of crayons, you'd be the giant name-brand one with the built-in sharpener.",
            "\(userName) you should be thanked more often. so thank you!!",
            "\(userName) our community is better because you're in it.",
            "\(userName) someone is getting through something hard right now because you've got their back. ",
            "\(userName) you have the best ideas.",
            "\(userName) you always find something special in the most ordinary things.",
            "\(userName) everyone gets knocked down sometimes, but you always get back up and keep going.",
            "\(userName) you're a candle in the darkness.",
            "\(userName) you're a great example to others.",
            "\(userName) being around you is like being on a happy little vacation.",
            "\(userName) you always know just what to say.",
            "\(userName) you're always learning new things and trying to better yourself, which is awesome.",
            "\(userName) if someone based an internet meme on you, it would have impeccable grammar.",
            "\(userName) you could survive a zombie apocalypse.",
            "\(userName) you're more fun than bubble wrap.",
            "\(userName) when you make a mistake, you try to fix it.",
            "\(userName) who raised you? they deserve a medal for a job well done.",
            "\(userName) you're great at figuring stuff out.",
            "\(userName) your voice is magnificent.",
            "\(userName) the people you love are lucky to have you in their lives.",
            "\(userName) you're like a breath of fresh air.",
            "\(userName) you make my insides jump around in the best way.",
            "\(userName) you're so thoughtful.",
            "\(userName) your creative potential seems limitless.",
            "\(userName) your name suits you to a t.",
            "\(userName) your quirks are so you and i love that.",
            "\(userName) when you say you will do something, i trust you.",
            "\(userName) somehow you make time stop and fly at the same time.",
            "\(userName) when you make up your mind about something, nothing stands in your way.",
            "\(userName) you seem to really know who you are.",
            "\(userName) any team would be lucky to have you on it.",
            "\(userName) i bet you do the crossword puzzle in ink.",
            "\(userName) babies and small animals probably love you.",
            "\(userName) if you were a scented candle they'd call it perfectly imperfect (and it would smell like summer).",
            "\(userName) there's ordinary, and then there's you.",
            "\(userName) you're someone's reason to smile.",
            "\(userName) you're even better than a unicorn, because you're real.",
            "\(userName) how do you keep being so funny and making everyone laugh?",
            "\(userName) you have a good head on your shoulders.",
            "\(userName) has anyone ever told you that you have great posture?",
            "\(userName) the way you treasure your loved ones is incredible.",
            "\(userName) you're really something special.",
            "\(userName) thank you for being you.",
            "I love spending time with you \(userName)",
            "You are appreciated \(userName)",
            "You look beautiful \(userName)",
            "You are the most amazing person in this world  \(userName)",
            "You make people feel loved \(userName)",
            "I love how you patiently listen \(userName)",
            "I respect you so much \(userName)",
            "You're an excellent partner \(userName)",
            "I have got your back \(userName)",
            "You're so thoughtful \(userName)",
            "I appreciate what you do for your family \(userName)",
            "There's no one like you \(userName)",
            "You are a thoughtful person \(userName)",
            "You're amazing and i can't say that enough \(userName)",
            "You've helped people become a better person \(userName)",
            "You are loved \(userName)",
            "I am amazed at how well you balance work and home life \(userName)",
            "I love the way you appreciate the little things \(userName)",
            "I can't thank you enough for understanding me  \(userName)",
            "I am so proud of your achievements \(userName)",
            "You are the best friend one could ask for \(userName)",
            "You are a great friend \(userName)",
            "You're a light during dark times \(userName)",
            "You are an excellent friend \(userName)",
            "You know how to make people comfortable \(userName)",
            "You always send out loving vibes \(userName)",
            "You are a positive person \(userName)",
            "You are always ready to help people \(userName)",
            "There can't be another you you are perfect! \(userName)",
            "Your opinion is valued \(userName)",
            "Thanks for dealing with my mood swings \(userName)",
            "You are a brave person  \(userName)",
            "You are a reliable person \(userName)",
            "You are really good at what you do \(userName)",
            "You are a dedicated employee \(userName)",
            "Keep up the great work \(userName)",
            "You're an awesome worker \(userName)",
            "You can be trusted  \(userName)",
            "You amaze us with your hard work \(userName)",
            "It's surprising how well you perform, even under pressure \(userName)",
            "You're a great example for your co-workers \(userName)",
            "Your work ethic speaks for itself \(userName)",
            "You bring a lot of positivity to your work \(userName)",
            "You are appreciated \(userName)",
            "Your work never ceases to amaze us \(userName)",
            "You always exceed expectations \(userName)",
            "You have a great future \(userName)",
            "Your work is unparalleled \(userName)",
            "Your hard work speaks for itself \(userName)",
            "You have good leadership skills \(userName)",
            "You are creative \(userName)",
            "You are the reason i smile every day  \(userName)",
            "You are a positive person \(userName)",
            "You are the best \(userName)",
            "You're incredible \(userName)",
            "You have the biggest heart \(userName)",
            "You are so talented \(userName)",
            "You're a well-behaved child \(userName)",
            "You're a rock star \(userName)",
            "You're appreciated just the way you are \(userName)",
            "You are a blessing from above \(userName)",
            "You are so humble \(userName)",
            "You're a great example to others  \(userName)",
            "You're beautiful both inside and out \(userName)",
            "You have a heart of gold \(userName)",
            "You are making a difference \(userName)",
            "You are so strong  \(userName)"
        ]
        
        //QuoteArray = Compliments.QuoteArray
        
        let max = QuoteArray.count
        
        addBackButton()
        synthesizer.delegate = self

        //Still Image View
        corgiView.translatesAutoresizingMaskIntoConstraints = false
        corgiView.contentMode = .scaleAspectFill
        // imageView.sizeToFit()
        corgiView.isUserInteractionEnabled = true
        view.addSubview(corgiView)
        corgiView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        corgiView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        corgiView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        corgiView.heightAnchor.constraint(equalTo: corgiView.widthAnchor, multiplier: 1).isActive = true


        //Gif Image Manipulation
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        // imageView.sizeToFit()
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
        

        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(recognizer:)))
        imageView.addGestureRecognizer(pan)
        
        //Gif Animation Properties
        imageView.animationImages = corgiGif?.images
        // Set the duration of the UIImage
        imageView.animationDuration = corgiGif!.duration
        // Set the repetitioncount
        imageView.animationRepeatCount = 0
        // Start the animation
        imageView.stopAnimating()
        
        
        
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      bannerView.alpha = 0
      UIView.animate(withDuration: 1, animations: {
        bannerView.alpha = 1
      })
    }
    
    //Longpress Handler
    @objc func handleLP(recognizer: UILongPressGestureRecognizer) {
        
        switch recognizer.state{
            
        default: break
            
        }
        
    }
    
    //Pauses speech when fired
    @objc func timerDidFire(_ timer: Timer?) {
        synthesizer.pauseSpeaking(at: .immediate)
        
    }
    
    // Pan handler when rubbing
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state{
            
        //Start Stroking
        case .began:
            
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.impactOccurred()

            //Remove Image When Start
            corgiView.image = nil
            
            //rub image remove
            rub_image.isHidden = true
            //rub_image.image = nil
            
            //Gif Animate
            imageView.startAnimating()
    
            getRandom()
      
        //Continue Stroking
        case .changed:
            if ViewController.gestureDidFireTimer?.isValid ?? false {
                ViewController.gestureDidFireTimer?.invalidate()
            }

            ViewController.gestureDidFireTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerDidFire(_:)), userInfo: nil, repeats: false)

            synthesizer.continueSpeaking();

             
        //Stop Stroking
        case .ended:
            
//            let generator = UIImpactFeedbackGenerator(style: .medium)
//            generator.impactOccurred()
            
            if ViewController.gestureDidFireTimer?.isValid ?? false {
                ViewController.gestureDidFireTimer?.invalidate()
            }
            
            
            corgiView.image = UIImage.init(named: "corgi_still")
            imageView.stopAnimating()
            
            rub_image.isHidden = false
            
            synthesizer.stopSpeaking(at: .word)
                            
                
        default: break
            
        }
        
    }
    
    //Getting random string from Stroke array
    func getRandom() {
        
        var copy = [String]()

        for i in 1...QuoteArray.count {
            if copy.isEmpty {
                copy = QuoteArray;
                copy.shuffle()

                speechText.text = copy[i-1]
          
            }
        
            let element = copy.removeFirst() ;

            utterance = AVSpeechUtterance(string: element)

            synthesizer.speak(utterance)

        }
 
    }
   
    //Counting the number of stroked
    func countStrokes(){
        
        strokeCount += 1
        //print(strokeCount)
    
    }
    
    
}


extension ViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
        speechText.text = utterance.speechString
        
        if(mainmenu.getSwitch() == true){
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        //countStrokes()

    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        //Speaking is done, enable speech UI for next round
        
        speechText.text = utterance.speechString
 
        countStrokes()

    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        //Speaking is done, enable speech UI for next round

    }
   
    
    func addBackButton() {

        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    
    @IBAction func backAction(_ sender: UIStoryboardSegue) {
        let _ = self.navigationController?.popToRootViewController(animated: true)

    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UILabel {
    
    func setTyping(text: String, characterDelay: TimeInterval = 5.0) {
        self.text = ""
        
        let writingTask = DispatchWorkItem { [weak self] in
            text.forEach { char in
                DispatchQueue.main.async {
                    self?.text?.append(char)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
        queue.asyncAfter(deadline: .now() + 0.05, execute: writingTask)
    }
}
