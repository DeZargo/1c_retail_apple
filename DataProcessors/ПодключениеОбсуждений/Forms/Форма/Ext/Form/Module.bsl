﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("РегистрацияИнформационнойБазыСистемыВзаимодействия", Метаданные) Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	КонтейнерСостояний = Новый Структура;
	КонтейнерСостояний.Вставить("СерверВзаимодействия", "wss://1cdialog.com:443");
	КонтейнерСостояний.Вставить("ИмяИнформационнойБазы", Метаданные.КраткаяИнформация);
	КонтейнерСостояний.Вставить("СостояниеРегистрации", ТекущееСостояниеРегистрации());
	// Возможные значения:
	// "ТребуетсяСоздатьАдминистратора"
	// "НеЗарегистрирована"
	// "Зарегистрирована"
	// "ОжиданиеВводаКодаПодтверждения"
	// "ОжиданиеОтветаСервераВзаимодействия".
	
	ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТребуетсяСоздатьАдминистратораПояснениеОбработкаНавигационнойСсылки(Элемент, 
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Зарегистрироваться(Команда)
	
	СостояниеРегистрации = КонтейнерСостояний.СостояниеРегистрации;
	
	Если СостояниеРегистрации = "ТребуетсяРазблокировать" Тогда 
		ПриРазблокировке();
	ИначеЕсли СостояниеРегистрации = "НеЗарегистрирована" Тогда 
		ПриПолученииКодаРегистрации();
	ИначеЕсли СостояниеРегистрации = "ОжиданиеВводаКодаПодтверждения" Тогда 
		ПриРегистрации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	СостояниеРегистрации = КонтейнерСостояний.СостояниеРегистрации;
	
	Если СостояниеРегистрации = "ОжиданиеВводаКодаПодтверждения" Тогда 
		ПриОтказеОтВводаКодаПодтверждения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеОбработчикиСобытий

&НаКлиенте
Процедура ПриРазблокировке()
	
	ОбсужденияСлужебныйВызовСервера.Разблокировать();
	
	КонтейнерСостояний.СостояниеРегистрации = "Зарегистрирована";
	ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	
	Оповестить("ОбсужденияПодключены", Истина);
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПолученииКодаРегистрации()
	
	Если ПустаяСтрока(АдресЭлектроннойПочты) Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Адрес электронной почты не заполнен'"));
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(АдресЭлектроннойПочты) Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Адрес электронной почты содержит ошибки'"));
		Возврат;
	КонецЕсли;
	
	СерверВзаимодействия = КонтейнерСостояний.СерверВзаимодействия;
	
	ПараметрыРегистрации = Новый ПараметрыРегистрацииИнформационнойБазыСистемыВзаимодействия;
	ПараметрыРегистрации.АдресСервера = СерверВзаимодействия;
	ПараметрыРегистрации.АдресЭлектроннойПочты = АдресЭлектроннойПочты;
	
	Оповещение = Новый ОписаниеОповещения("ПослеУспешногоПолученияКодаРегистрации", ЭтотОбъект,,
		"ПриОбработкеОшибкиПолученияКодаРегистрации", ЭтотОбъект);
	СистемаВзаимодействия.НачатьРегистрациюИнформационнойБазы(Оповещение, ПараметрыРегистрации);
	
	КонтейнерСостояний.СостояниеРегистрации = "ОжиданиеОтветаСервераВзаимодействия";
	ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУспешногоПолученияКодаРегистрации(РегистрацияВыполнена, ТекстСообщения, Контекст) Экспорт
	
	ПоказатьПредупреждение(, ТекстСообщения);
	
	КонтейнерСостояний.СостояниеРегистрации = "ОжиданиеВводаКодаПодтверждения";
	ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОбработкеОшибкиПолученияКодаРегистрации(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	
	КонтейнерСостояний.СостояниеРегистрации = "НеЗарегистрирована";
	ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриРегистрации()
	
	Если ПустаяСтрока(КодРегистрации) Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Код регистрации не заполнен'"));
		Возврат;
	КонецЕсли;
	
	СерверВзаимодействия  = КонтейнерСостояний.СерверВзаимодействия;
	ИмяИнформационнойБазы = КонтейнерСостояний.ИмяИнформационнойБазы;
	
	ПараметрыРегистрации = Новый ПараметрыРегистрацииИнформационнойБазыСистемыВзаимодействия;
	ПараметрыРегистрации.АдресСервера = СерверВзаимодействия;
	ПараметрыРегистрации.АдресЭлектроннойПочты = АдресЭлектроннойПочты;
	ПараметрыРегистрации.ИмяИнформационнойБазы = ИмяИнформационнойБазы;
	ПараметрыРегистрации.КодАктивации = СокрЛП(КодРегистрации);
	
	Оповещение = Новый ОписаниеОповещения("ПослеУспешнойРегистрации", ЭтотОбъект,,
		"ПриОбработкеОшибкиРегистрации", ЭтотОбъект);
	
	СистемаВзаимодействия.НачатьРегистрациюИнформационнойБазы(Оповещение, ПараметрыРегистрации);
	
	КонтейнерСостояний.СостояниеРегистрации = "ОжиданиеОтветаСервераВзаимодействия";
	ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУспешнойРегистрации(РегистрацияВыполнена, ТекстСообщения, Контекст) Экспорт
	
	Если РегистрацияВыполнена Тогда 
		Оповестить("ОбсужденияПодключены", Истина);
		КонтейнерСостояний.СостояниеРегистрации = "Зарегистрирована";
	Иначе 
		ПоказатьПредупреждение(, ТекстСообщения);
		КонтейнерСостояний.СостояниеРегистрации = "ОжиданиеВводаКодаПодтверждения";
	КонецЕсли;
	
	ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОбработкеОшибкиРегистрации(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке);
	
	КонтейнерСостояний.СостояниеРегистрации = "ОжиданиеВводаКодаПодтверждения";
	ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтказеОтВводаКодаПодтверждения()
	
	Оповещение = Новый ОписаниеОповещения("ПослеПодтвержденияОтказаВводаКодаПодтверждения", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, 
		НСтр("ru = 'При отказе от ввода высланный на электронную почту код станет недействительным.
		           |Продолжение будет возможно только с запросом нового кода.'"), 
		РежимДиалогаВопрос.ОКОтмена,, КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодтвержденияОтказаВводаКодаПодтверждения(РезультатВопроса, Контекст) Экспорт 
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда 
		КонтейнерСостояний.СостояниеРегистрации = "НеЗарегистрирована";
		ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииСостоянияФормы(КонтейнерСостояний, ЭтотОбъект) 
	
	СостояниеРегистрации = КонтейнерСостояний.СостояниеРегистрации;
	
	Если СостояниеРегистрации = "ОжиданиеВводаКодаПодтверждения" Тогда
		ЭтотОбъект.КодРегистрации = "";
	КонецЕсли;
	
	УстановитьСтраницу(КонтейнерСостояний, ЭтотОбъект);
	
	Элементы = ЭтотОбъект.Элементы;
	
	ОбновитьВидимостьКнопокКоманднойПанели(КонтейнерСостояний, 
		Элементы.Зарегистрироваться, Элементы.Закрыть, Элементы.Назад);
	
КонецПроцедуры

#КонецОбласти

#Область МодельПредставления

&НаСервереБезКонтекста
Функция ТекущееСостояниеРегистрации()
	
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	Если ПустаяСтрока(ТекущийПользователь.Имя) Тогда 
		Возврат "ТребуетсяСоздатьАдминистратора";
	КонецЕсли;
	
	Если ОбсужденияСлужебный.Заблокированы() Тогда 
		Возврат "ТребуетсяРазблокировать";
	КонецЕсли;
	
	Возврат ?(СистемаВзаимодействия.ИнформационнаяБазаЗарегистрирована(),
		"Зарегистрирована", "НеЗарегистрирована");
	
КонецФункции

#КонецОбласти

#Область Представления

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтраницу(КонтейнерСостояний, ЭтотОбъект)
	
	СостояниеРегистрации = КонтейнерСостояний.СостояниеРегистрации;
	Элементы = ЭтотОбъект.Элементы;
	
	Если СостояниеРегистрации = "ТребуетсяСоздатьАдминистратора" Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ТребуетсяСоздатьАдминистратора;
	ИначеЕсли СостояниеРегистрации = "ТребуетсяРазблокировать" Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ТребуетсяРазблокировать;
	ИначеЕсли СостояниеРегистрации = "НеЗарегистрирована" Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ПредложениеРегистрации;
	ИначеЕсли СостояниеРегистрации = "ОжиданиеВводаКодаПодтверждения" Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ВводКодаРегистрации;
	ИначеЕсли СостояниеРегистрации = "ОжиданиеОтветаСервераВзаимодействия" Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ДлительнаяОперация;
	ИначеЕсли СостояниеРегистрации = "Зарегистрирована" Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.РегистрацияЗавершена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьКнопокКоманднойПанели(КонтейнерСостояний,
	Зарегистрироваться, Закрыть, Назад)
	
	СостояниеРегистрации = КонтейнерСостояний.СостояниеРегистрации;
	
	Если СостояниеРегистрации = "ТребуетсяСоздатьАдминистратора" Тогда 
		Зарегистрироваться.Видимость = Ложь;
		Назад.Видимость = Ложь;
	ИначеЕсли СостояниеРегистрации = "ТребуетсяРазблокировать" Тогда 
		Зарегистрироваться.Видимость = Истина;
		Зарегистрироваться.Заголовок = НСтр("ru = 'Восстановить подключение'");
		Назад.Видимость = Ложь;
	ИначеЕсли СостояниеРегистрации = "НеЗарегистрирована" Тогда 
		Зарегистрироваться.Видимость = Истина;
		Назад.Видимость = Ложь;
	ИначеЕсли СостояниеРегистрации = "ОжиданиеВводаКодаПодтверждения" Тогда 
		Зарегистрироваться.Видимость = Истина;
		Назад.Видимость = Истина;
	ИначеЕсли СостояниеРегистрации = "ОжиданиеОтветаСервераВзаимодействия" Тогда 
		Зарегистрироваться.Видимость = Ложь;
		Назад.Видимость = Ложь;
	ИначеЕсли СостояниеРегистрации = "Зарегистрирована" Тогда 
		Зарегистрироваться.Видимость = Ложь;
		Назад.Видимость = Ложь;
		Закрыть.КнопкаПоУмолчанию = Истина;
		Закрыть.Заголовок = НСтр("ru = 'Готово'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти