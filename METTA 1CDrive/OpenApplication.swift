//
//  OpenApplication.swift
//  salesManager
//
//  Created by Роман Кокорев on 18.02.2024.
//

import UIKit
import EventKit
import EventKitUI

class OpenApplication: UIViewController {
    
    let eventStore = EKEventStore()
    
    func createReminder() {
        // Создаем URL для приложения напоминание с параметрами
        let reminderText = "" // Текст напоминания
        let reminderDate = Date().addingTimeInterval(60 * 60 * 24) // Срок напоминания - через 24 часа
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Формат даты для URL-схемы
        let reminderDateString = dateFormatter.string(from: reminderDate)
        let reminderURLString = "x-apple-reminder://?title=\(reminderText)&dueDateTimeZoneless=\(reminderDateString)" // URL-схема с параметрами
        let reminderURL = URL(string: reminderURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! // URL с экранированием специальных символов
        // Проверяем, может ли наше приложение открыть этот URL
        if UIApplication.shared.canOpenURL(reminderURL) {
            // Открываем приложение напоминание с параметрами и без обработчика завершения
            UIApplication.shared.open(reminderURL)
        } else {
            // Выводим сообщение об ошибке, если URL не может быть открыт
            print("Cannot open reminder app")
        }
    }
    
    func openWhatsAppChat(contactNumber: String) {
        // Создаем URL для WhatsApp с номером контакта
        let whatsappURLString = "whatsapp://send?phone=\(contactNumber)" // URL-схема с параметром
        let whatsappURL = URL(string: whatsappURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! // URL с экранированием специальных символов
        // Проверяем, может ли наше приложение открыть этот URL
        if UIApplication.shared.canOpenURL(whatsappURL) {
            // Открываем диалог в WhatsApp с указанным контактом и без обработчика завершения
            UIApplication.shared.open(whatsappURL)
        } else {
            // Выводим сообщение об ошибке, если URL не может быть открыт
            print("Cannot open WhatsApp chat")
        }
    }
    
    func openTelegramChat(userName: String) {
        // Создаем URL для Telegram с именем пользователя
        let userName = "durov" // Имя пользователя в Telegram
        let telegramURLString = "tg://resolve?domain=\(userName)" // URL-схема с параметром
        let telegramURL = URL(string: telegramURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! // URL с экранированием специальных символов
        // Проверяем, может ли наше приложение открыть этот URL
        if UIApplication.shared.canOpenURL(telegramURL) {
            // Открываем диалог в Telegram с указанным пользователем и без обработчика завершения
            UIApplication.shared.open(telegramURL)
        } else {
            // Выводим сообщение об ошибке, если URL не может быть открыт
            print("Cannot open Telegram chat")
        }
    }    
}
