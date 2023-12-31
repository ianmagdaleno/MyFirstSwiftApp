//
//  ViewController.swift
//  CalendarApp
//
//  Created by mac on 28/11/23.
//

import UIKit
import CalendarKit
import EventKit

class CalendarViewController: DayViewController {
    private let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        requestAcessToCalendar()
        subscribeToNotifications()
    }
    
    func requestAcessToCalendar() {
        eventStore.requestAccess(to: .event) { sucess, erro in
            
        }
    }
    
    func subscribeToNotifications(){
        NotificationCenter.default.addObserver(self ,
                                               selector: #selector(storeChanged(_:)),
                                               name: .EKEventStoreChanged,
                                               object: nil)
    }
    
    @objc func storeChanged(_ notification: Notification){
        reloadData()
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                      end: endDate,
                                                      calendars: nil)
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map { ekEvent -> Event in
            let ckEvent = Event()
            ckEvent.dateInterval.start = ekEvent.startDate
            ckEvent.dateInterval.end = ekEvent.endDate
            ckEvent.isAllDay = ekEvent.isAllDay
            ckEvent.text = ekEvent.title
            if let eventColor = ekEvent.calendar.cgColor{
                ckEvent.color = UIColor(cgColor: eventColor)
            }
            return ckEvent
        }
        return calendarKitEvents
    }
}


