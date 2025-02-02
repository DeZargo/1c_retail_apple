﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИС.ОтработатьВходящийДокументПротоколаОбмена(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Документ)
	 И НЕ Метаданные.ОпределяемыеТипы.ДокументыВЕТИС.Тип.СодержитТип(ТипЗнч(Документ)) Тогда
		РеквизитыДокументаОснования = Новый ФиксированнаяСтруктура(
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Ссылка, Проведен"));
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	ЗаполнитьСтруктуруДействий();
	ЗаполнитьДеревоФайлов();
	
	ПодключенныеХозяйствующиеСубъектыДокумента.ЗагрузитьЗначения(ПредприятияХозяйствующиеСубъектыВЕТИС.ПодключенныеХозяйствующиеСубъектыДокумента(Документ));
	Если ПодключенныеХозяйствующиеСубъектыДокумента.Количество() = 0 Тогда
		Элементы.ВыполнитьОбмен.Доступность = Ложь;
	КонецЕсли;
	
	// ИнтеграцияИС
	Если РеквизитыДокументаОснования <> Неопределено Тогда
		ИнтеграцияИС.ПриСозданииНаСервереВФормеДокументаОснования(
			ЭтотОбъект,
			РеквизитыДокументаОснования,
			ИнтеграцияИС.ПараметрыИнтеграцииВФорме("ВетИС",ИнтеграцияИС.ИмяЭлементаДляРазмещения()));
	КонецЕсли;
	// Конец ИнтеграцияИС
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтеграцияИСКлиент.РазвернутьДеревоРекурсивно(ДеревоФайлов, Элементы.ДеревоФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ПерезаполнитьДерево = Ложь;
	
	Если ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы())
	 И (Параметр.Ссылка = Документ Или (Параметр.Свойство("Основание") И Параметр.Основание = Документ)) Тогда
		
		ПерезаполнитьДерево = Истина;
		
	ИначеЕсли ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияВыполненОбмен(ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы())
	 И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВЕТИСВФормахДокументов)) Тогда
		
		ПерезаполнитьДерево = Истина;
		
	ИначеЕсли СтрНачинаетсяС(ИмяСобытия, ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененОбъект(ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы())) Тогда
		
		ПерезаполнитьДерево = Истина;
		
	КонецЕсли;
	
	Если ПерезаполнитьДерево Тогда
		ОбновитьДерево();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ОчиститьСообщения();
	
	ДокументыВЕТИС = Новый Массив;
	Для Каждого СтрокаДерева Из ДеревоФайлов.ПолучитьЭлементы() Цикл
		Если ДокументыВЕТИС.Найти(СтрокаДерева.Документ) = Неопределено Тогда
			ДокументыВЕТИС.Добавить(СтрокаДерева.Документ);
		КонецЕсли;
	КонецЦикла;
	Если ДокументыВЕТИС.Количество() = 0 Тогда
		ДокументыВЕТИС = Неопределено;
	КонецЕсли;
	
	РезультатОбмена = ИнтеграцияВЕТИСВызовСервера.ПроверитьРезультатОбработкиЗаявок(
		ПодключенныеХозяйствующиеСубъектыДокумента.ВыгрузитьЗначения(),
		ДокументыВЕТИС,
		УникальныйИдентификатор);
	
	ИнтеграцияВЕТИСКлиент.ОбработатьРезультатОбмена(РезультатОбмена, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСообщенияXML(Команда)
	
	ИнтеграцияИСКлиент.ПоказатьСообщенияОперации(ЭтотОбъект, "ВЕТИС", Элементы.ДеревоФайлов.ТекущаяСтрока, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Передать(Команда)
	
	ДальнейшееДействие = Неопределено;
	Если ИнтеграцияИСКлиент.ПроверитьВозможностьДействия(ЭтотОбъект, "Передать", ДальнейшееДействие) Тогда
		ИнтеграцияВЕТИСКлиент.ПодготовитьКПередаче(
			Элементы.ДеревоФайлов.ТекущиеДанные.Документ,
			ИнтеграцияВЕТИСКлиентСервер.СтруктураПараметрыПередачи(ДальнейшееДействие));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	ДальнейшееДействие = Неопределено;
	Если ИнтеграцияИСКлиент.ПроверитьВозможностьДействия(ЭтотОбъект, "Отменить", ДальнейшееДействие) Тогда
		ИнтеграцияВЕТИСКлиент.ПодготовитьКПередаче(
			Элементы.ДеревоФайлов.ТекущиеДанные.Документ,
			ИнтеграцияВЕТИСКлиентСервер.СтруктураПараметрыПередачи(ДальнейшееДействие));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ДальнейшееДействие = Неопределено;
	Если ИнтеграцияИСКлиент.ПроверитьВозможностьДействия(ЭтотОбъект, "Отменить", ДальнейшееДействие) Тогда
		ИнтеграцияВЕТИСКлиент.ПодготовитьКПередаче(
			Элементы.ДеревоФайлов.ТекущиеДанные.Документ,
			ИнтеграцияВЕТИСКлиентСервер.СтруктураПараметрыПередачи(ДальнейшееДействие));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСтатус(Команда)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.ДеревоФайлов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСтатусНаСервере(ТекущиеДанные.Документ);
	
	Оповестить(ИнтеграцияИСКлиентСервер.ИмяСобытияВыполненОбмен(ИнтеграцияВЕТИСКлиентСервер.ИмяПодсистемы()));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовДереваФайлов

&НаКлиенте
Процедура ДеревоФайловПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоФайлов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КомандыПередать = Новый Массив;
	КомандыПередать.Добавить(Элементы.ДеревоФайловДействиеПередать);
	КомандыПередать.Добавить(Элементы.ДеревоФайловКонтекстноеМенюДействиеПередать);
	Для Каждого Элемент Из КомандыПередать Цикл
		Элемент.Доступность = Ложь;
	КонецЦикла;
	
	КомандыПодтвердить = Новый Массив;
	КомандыПодтвердить.Добавить(Элементы.ДеревоФайловДействиеПодтвердить);
	КомандыПодтвердить.Добавить(Элементы.ДеревоФайловКонтекстноеМенюДействиеПодтвердить);
	Для Каждого Элемент Из КомандыПодтвердить Цикл
		Элемент.Доступность = Ложь;
	КонецЦикла;
	
	КомандыОтменить = Новый Массив;
	КомандыОтменить.Добавить(Элементы.ДеревоФайловДействиеОтменить);
	КомандыОтменить.Добавить(Элементы.ДеревоФайловКонтекстноеМенюДействиеОтменить);
	Для Каждого Элемент Из КомандыОтменить Цикл
		Элемент.Доступность = Ложь;
	КонецЦикла;
	
	Для Каждого ЭлементСписка Из ТекущиеДанные.ДальнейшиеДействия Цикл
		
		Если Действия.Передать.Найти(ЭлементСписка.Значение) <> Неопределено Тогда
			Для Каждого Элемент Из КомандыПередать Цикл
				Элемент.Доступность = Истина;
			КонецЦикла;
		ИначеЕсли Действия.Подтвердить.Найти(ЭлементСписка.Значение) <> Неопределено Тогда
			Для Каждого Элемент Из КомандыПодтвердить Цикл
				Элемент.Доступность = Истина;
			КонецЦикла;
		ИначеЕсли Действия.Отменить.Найти(ЭлементСписка.Значение) <> Неопределено Тогда
			Для Каждого Элемент Из КомандыОтменить Цикл
				Элемент.Доступность = Истина;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ПоказатьСообщенияОперации(ЭтотОбъект, "ВЕТИС", ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстДокументаВЕТИСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	// ИнтеграцияИС
	Если РеквизитыДокументаОснования <> Неопределено Тогда
		ИнтеграцияИСКлиент.ОбработкаНавигационнойСсылкиВФормеДокументаОснования(
			ЭтотОбъект,
			РеквизитыДокументаОснования,
			Элемент,
			НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка);
	КонецЕсли;
	// Конец ИнтеграцияИС
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДерево()
	
	ЗаполнитьДеревоФайлов();
	ИнтеграцияИСКлиент.РазвернутьДеревоРекурсивно(ДеревоФайлов, Элементы.ДеревоФайлов);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ИнтеграцияИС.УстановитьУсловноеОформлениеПротоколаОбмена(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруДействий()
	Действия = Новый Структура;
	Действия.Вставить("Передать",    Новый Массив);
	Действия.Вставить("Подтвердить", Новый Массив);
	Действия.Вставить("Отменить",    Новый Массив);
	
	Действия.Передать.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПередайтеДанные);
	
	Действия.Подтвердить.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ПодтвердитеУсловияПеремещения);
	
	Действия.Отменить.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОтменитеОперацию);
	Действия.Отменить.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюВЕТИС.ОтменитеПередачуДанных);
КонецПроцедуры

&НаСервере
Процедура РассчитатьСтатусНаСервере(ДокументСсылка)
	
	ИнтеграцияВЕТИС.РассчитатьСтатусДокументаВЕТИСПоДаннымПротоколаОбмена(ДокументСсылка);
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеОперации(СтрокаПоследовательности, ДокументСсылка, ВыборкаПоФайлам = Неопределено)
	
	Если СтрокаПоследовательности = Неопределено Тогда
		
		Возврат "";
		
	ИначеЕсли СтрокаПоследовательности.ТипСообщения = Перечисления.ТипыЗапросовИС.Исходящий Тогда
		
		Если ВыборкаПоФайлам = Неопределено Тогда
			Возврат ИнтеграцияВЕТИС.ОписаниеОперацииПередачиДанных(СтрокаПоследовательности.Операция, Неопределено, Неопределено);
		Иначе
			Возврат ИнтеграцияВЕТИС.ОписаниеОперацииПередачиДанных(СтрокаПоследовательности.Операция, Неопределено, ВыборкаПоФайлам.Версия);
		КонецЕсли;
		
	ИначеЕсли СтрокаПоследовательности.ТипСообщения = Перечисления.ТипыЗапросовИС.Входящий Тогда
		
		Возврат ИнтеграцияВЕТИС.ОписаниеОперацииПолученияДанных(СтрокаПоследовательности.Операция);
		
	Иначе
		
		Возврат Строка(СтрокаПоследовательности.Операция);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ТаблицаДокументы(Документ = Неопределено)
	
	ТаблицаДокументы = Новый ТаблицаЗначений;
	ТаблицаДокументы.Колонки.Добавить("Ссылка",              Метаданные.Справочники.ВЕТИСПрисоединенныеФайлы.Реквизиты.Документ.Тип);
	ТаблицаДокументы.Колонки.Добавить("Статус",              Метаданные.РегистрыСведений.СтатусыДокументовВЕТИС.Ресурсы.Статус.Тип);
	ТаблицаДокументы.Колонки.Добавить("ДальнейшееДействие1", Новый ОписаниеТипов("ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС"));
	ТаблицаДокументы.Колонки.Добавить("ДальнейшееДействие2", Новый ОписаниеТипов("ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС"));
	ТаблицаДокументы.Колонки.Добавить("ДальнейшееДействие3", Новый ОписаниеТипов("ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюВЕТИС"));
	
	Если Документ <> Неопределено Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Таблица.Документ            КАК Ссылка,
		|	Таблица.Статус              КАК Статус,
		|	Таблица.ДальнейшееДействие1 КАК ДальнейшееДействие1,
		|	Таблица.ДальнейшееДействие2 КАК ДальнейшееДействие2,
		|	Таблица.ДальнейшееДействие3 КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовВЕТИС КАК Таблица
		|ГДЕ
		|	Таблица.Документ = &ДокументСсылка
		|");
		
		Запрос.УстановитьПараметр("ДокументСсылка", Документ);
		
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаДокументы.Добавить(), Выборка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаДокументы;
	
КонецФункции

#Область ЗаполнениеДереваФайлов

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаИнвентаризацияПродукцииВЕТИС(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ИнвентаризацияПродукцииВЕТИС;
	
	ЗаполнитьПоОснованиюДокументаВЕТИС(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаВходящаяТранспортнаяОперацияВЕТИС(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ВходящаяТранспортнаяОперацияВЕТИС;
	
	ЗаполнитьПоОснованиюДокументаВЕТИС(МетаданныеДокумента, ДокументОснование, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаИсходящаяТранспортнаяОперацияВЕТИС(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ИсходящаяТранспортнаяОперацияВЕТИС;
	
	ЗаполнитьПоОснованиюДокументаВЕТИС(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаПроизводственнаяОперацияВЕТИС(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ПроизводственнаяОперацияВЕТИС;
	
	ЗаполнитьПоОснованиюДокументаВЕТИС(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаВЕТИС(МетаданныеДокументаВЕТИС, ДокументОснование, ДобавитьГиперссылку = Истина)
	
	ШаблонТекстаЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                    КАК Ссылка,
	|	СтатусыДокументовВЕТИС.Статус              КАК Статус,
	|	СтатусыДокументовВЕТИС.ДальнейшееДействие1 КАК ДальнейшееДействие1,
	|	СтатусыДокументовВЕТИС.ДальнейшееДействие2 КАК ДальнейшееДействие2,
	|	СтатусыДокументовВЕТИС.ДальнейшееДействие3 КАК ДальнейшееДействие3
	|ИЗ
	|	Документ.%1 КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовВЕТИС КАК СтатусыДокументовВЕТИС
	|		ПО СтатусыДокументовВЕТИС.Документ = ТаблицаДокумента.Ссылка
	|ГДЕ
	|	ТаблицаДокумента.ДокументОснование = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаДокумента.Дата";
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонТекстаЗапроса,
		МетаданныеДокументаВЕТИС.Имя);
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	ТаблицаДокументы = ТаблицаДокументы();
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаДокументы.Добавить(), Выборка);
	КонецЦикла;
	
	ЗаполнитьПоДокументу(ТаблицаДокументы, Истина);
	
	Если НЕ ДобавитьГиперссылку Тогда
		Возврат;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтатусыОформленияДокументовВЕТИС.Документ,
	|	СтатусыОформленияДокументовВЕТИС.СтатусОформления КАК Статус
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовВЕТИС КАК СтатусыОформленияДокументовВЕТИС
	|ГДЕ
	|	СтатусыОформленияДокументовВЕТИС.Основание = &ДокументОснование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтатусыОформления = Новый Структура;
	Пока Выборка.Следующий() Цикл
		СтатусыОформления.Вставить(Выборка.Документ.Метаданные().Имя, Выборка.Статус);
	КонецЦикла;
	
	Если СтатусыОформления[МетаданныеДокументаВЕТИС.Имя] <> Перечисления.СтатусыОформленияДокументовВЕТИС.Оформлено Тогда
		
		ПравоДобавления = ПравоДоступа("Добавление", МетаданныеДокументаВЕТИС);
		
		Шаблон = ИнтеграцияВЕТИС.ШаблонПредставленияДокументаВЕТИСДляПоляИнтеграции(
			МетаданныеДокументаВЕТИС,
			ДокументОснование);
		
		Если ПравоДобавления Тогда
			ТекстНадписи = Шаблон.ПредставлениеКомандыСоздать;
			ИмяКоманды   = Шаблон.ИмяКомандыСоздать;
		Иначе
			ТекстНадписи = Шаблон.ДокументНеСоздан;
			ИмяКоманды   = Неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекстНадписи) Тогда
			
			ФорматированнаяСтрока = Новый ФорматированнаяСтрока(
				ТекстНадписи,
				,
				?(ЗначениеЗаполнено(ИмяКоманды), ЦветаСтиля.ГиперссылкаЦвет, Неопределено),
				,
				ИмяКоманды);
			
			Строки = Новый Массив;
			
			Если ЗначениеЗаполнено(ТекстДокументаВЕТИС) Тогда
				Строки.Добавить(ТекстДокументаВЕТИС);
				Строки.Добавить(", ");
			КонецЕсли;
			Строки.Добавить(ФорматированнаяСтрока);
			
			ТекстДокументаВЕТИС = Новый ФорматированнаяСтрока(Строки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументу(ТаблицаДокументы, ОтображатьСИерархией = Ложь)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВременнаяТаблицаДокументы.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВременнаяТаблицаДокументы
	|ИЗ
	|	&ТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЕТИСПрисоединенныеФайлы.Документ КАК Документ,
	|	ВЕТИСПрисоединенныеФайлы.Ссылка КАК Ссылка,
	|	ВЕТИСПрисоединенныеФайлы.ТипСообщения КАК ТипСообщения,
	|	ВЕТИСПрисоединенныеФайлы.Операция КАК Операция,
	|	ВЕТИСПрисоединенныеФайлы.СообщениеОснование КАК СообщениеОснование,
	|	ВЕТИСПрисоединенныеФайлы.СтатусОбработки КАК СтатусОбработки,
	|	ВЕТИСПрисоединенныеФайлы.ДатаСоздания КАК ДатаСоздания,
	|	ВЫРАЗИТЬ(ВЕТИСПрисоединенныеФайлы.Описание КАК Строка(255)) КАК Описание,
	|	ВЕТИСПрисоединенныеФайлы.Версия КАК Версия
	|ПОМЕСТИТЬ втСообщения
	|ИЗ
	|	Справочник.ВЕТИСПрисоединенныеФайлы КАК ВЕТИСПрисоединенныеФайлы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|		ПО ВЕТИСПрисоединенныеФайлы.Документ = ВременнаяТаблицаДокументы.Ссылка
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Операция,
	|	ТипСообщения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сообщения.Документ КАК Документ,
	|	Сообщения.Ссылка КАК Ссылка,
	|	Сообщения.ТипСообщения КАК ТипСообщения,
	|	Сообщения.Операция КАК Операция,
	|	Сообщения.СообщениеОснование КАК СообщениеОснование,
	|	Сообщения.СтатусОбработки КАК СтатусОбработки,
	|	Сообщения.ДатаСоздания КАК ДатаСоздания,
	|	Сообщения.Описание КАК Описание,
	|	Сообщения.Версия КАК Версия
	|ПОМЕСТИТЬ Сообщения
	|ИЗ
	|	втСообщения КАК Сообщения
	|		ЛЕВОЕ СОЕДИНЕНИЕ втСообщения КАК ОтветыНаПередачуДанных
	|		ПО Сообщения.Ссылка = ОтветыНаПередачуДанных.СообщениеОснование
	|			И Сообщения.Операция = ОтветыНаПередачуДанных.Операция
	|			И (ОтветыНаПередачуДанных.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОчередьСообщенийВЕТИС КАК ОчередьПередачиДанныхВЕТИС
	|		ПО (ОчередьПередачиДанныхВЕТИС.Сообщение = Сообщения.Ссылка)
	|ГДЕ
	|	Сообщения.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
	|		И (ОчередьПередачиДанныхВЕТИС.Сообщение ЕСТЬ НЕ NULL
	|			ИЛИ ОтветыНаПередачуДанных.Ссылка ЕСТЬ НЕ NULL)
	|	ИЛИ Сообщения.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий)
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Операция,
	|	СообщениеОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПередачаДанных.Документ КАК Документ,
	|	ПередачаДанных.Ссылка КАК Запрос,
	|	ПередачаДанных.ДатаСоздания КАК ЗапросДатаСоздания,
	|	ЕСТЬNULL(ОтветыНаПередачуДанных.Ссылка, &ПустаяСсылка) КАК ОтветНаПередачуДанных,
	|	ЕСТЬNULL(ОтветыНаПередачуДанных.ДатаСоздания, ДАТАВРЕМЯ(1, 1, 1)) КАК ОтветНаПередачуДанныхДатаСоздания,
	|	ЕСТЬNULL(ОтветыНаПередачуДанных.СтатусОбработки, НЕОПРЕДЕЛЕНО) КАК ОтветНаПередачуДанныхСостояниеОбработки,
	|	ЕСТЬNULL(ПолученныеРезультатыЗапросовВЕТИС.Ссылка, &ПустаяСсылка) КАК ПолученРезультатЗапросаВЕТИС,
	|	ЕСТЬNULL(ПолученныеРезультатыЗапросовВЕТИС.ДатаСоздания, ДАТАВРЕМЯ(1, 1, 1)) КАК ПолученРезультатЗапросаВЕТИСДатаСоздания,
	|	ЕСТЬNULL(ПолученныеРезультатыЗапросовВЕТИС.СтатусОбработки, НЕОПРЕДЕЛЕНО) КАК ПолученРезультатЗапросаВЕТИССостояниеОбработки,
	|	ЕСТЬNULL(ОтветыНаЗапросыВЕТИС.Ссылка, &ПустаяСсылка) КАК ОтветНаЗапросВЕТИС,
	|	ЕСТЬNULL(ОтветыНаЗапросыВЕТИС.ДатаСоздания, ДАТАВРЕМЯ(1, 1, 1)) КАК ОтветНаЗапросВЕТИСДатаСоздания,
	|	ЕСТЬNULL(ОтветыНаЗапросыВЕТИС.СтатусОбработки, НЕОПРЕДЕЛЕНО) КАК ОтветНаЗапросВЕТИССостояниеОбработки
	|ИЗ
	|	Сообщения КАК ПередачаДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК ОтветыНаПередачуДанных
	|		ПО ПередачаДанных.Ссылка = ОтветыНаПередачуДанных.СообщениеОснование
	|			И ПередачаДанных.Операция = ОтветыНаПередачуДанных.Операция
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК ПолученныеРезультатыЗапросовВЕТИС
	|		ПО ПередачаДанных.Ссылка = ПолученныеРезультатыЗапросовВЕТИС.СообщениеОснование
	|			И (ПолученныеРезультатыЗапросовВЕТИС.Операция В (&ПолученРезультатЗапросаВЕТИС))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК ОтветыНаЗапросыВЕТИС
	|		ПО ПередачаДанных.Ссылка = ОтветыНаЗапросыВЕТИС.СообщениеОснование
	|			И (ОтветыНаЗапросыВЕТИС.Операция В (&ОтветНаЗапросВЕТИС))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПередачаДанных.ДатаСоздания,
	|	ЕСТЬNULL(ОтветыНаПередачуДанных.ДатаСоздания, ДАТАВРЕМЯ(1, 1, 1)) УБЫВ,
	|	ЕСТЬNULL(ПолученныеРезультатыЗапросовВЕТИС.ДатаСоздания, ДАТАВРЕМЯ(1, 1, 1)) УБЫВ,
	|	ЕСТЬNULL(ОтветыНаЗапросыВЕТИС.ДатаСоздания, ДАТАВРЕМЯ(1, 1, 1)) УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаДокументы.Ссылка КАК Документ,
	|	ЕСТЬNULL(Запрос.Ссылка, &ПустаяСсылка) КАК Ссылка,
	|	ЕСТЬNULL(Запрос.Операция, НЕОПРЕДЕЛЕНО) КАК Операция,
	|	ЕСТЬNULL(Запрос.ДатаСоздания, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаСоздания,
	|	ЕСТЬNULL(Запрос.Описание, """") КАК Описание,
	|	ЕСТЬNULL(Запрос.Версия, 1) КАК Версия
	|ИЗ
	|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК Запрос
	|		ПО Запрос.Документ = ВременнаяТаблицаДокументы.Ссылка
	|		И ((Запрос.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
	|			И Запрос.СообщениеОснование = &ПустаяСсылка)
	|		  ИЛИ
	|			(Запрос.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий)
	|			И Запрос.СообщениеОснование <> &ПустаяСсылка
	|			И Запрос.Операция В (&ОтветНаЗапросВЕТИС)))
	|УПОРЯДОЧИТЬ ПО
	|	Запрос.ДатаСоздания
	|ИТОГИ
	|	МАКСИМУМ(ДатаСоздания)
	|ПО
	|	Документ");
	
	Запрос.УстановитьПараметр("ТаблицаДокументы", ТаблицаДокументы);
	Запрос.УстановитьПараметр("ПустаяСсылка",     Справочники.ВЕТИСПрисоединенныеФайлы.ПустаяСсылка());
	
	Запрос.УстановитьПараметр("ОтветНаЗапросВЕТИС", Перечисления.ВидыОперацийВЕТИС.ОтветыНаЗапросыВЕТИС());
	Запрос.УстановитьПараметр("ПолученРезультатЗапросаВЕТИС", Перечисления.ВидыОперацийВЕТИС.ПолученныеРезультатыЗапросовВЕТИС());
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.ВыполнитьПакет();
	
	ДанныеСообщений     = Результат[Результат.Количество() - 2].Выгрузить();
	ВыборкаПоДокументам = Результат[Результат.Количество() - 1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		ПолноеИмя = ВыборкаПоДокументам.Документ.Метаданные().ПолноеИмя();
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
		ПоследовательностьОпераций = МенеджерОбъекта.ПоследовательностьОпераций(ВыборкаПоДокументам.Документ);
		
		Если ОтображатьСИерархией Тогда
			СтрокаПервогоУровня = ДеревоФайлов.ПолучитьЭлементы().Добавить();
			СтрокаПервогоУровня.Документ       = ВыборкаПоДокументам.Документ;
			СтрокаПервогоУровня.Представление  = ВыборкаПоДокументам.Документ;
			СтрокаПервогоУровня.ИндексКартинки = 5;
		Иначе
			СтрокаПервогоУровня = ДеревоФайлов;
		КонецЕсли;
		
		Операция          = Неопределено;
		ЕстьОшибка        = Ложь;
		ТребуетсяОжидание = Ложь;
		
		ВыборкаПоФайлам = ВыборкаПоДокументам.Выбрать();
		Пока ВыборкаПоФайлам.Следующий() Цикл
			
			Операция = ВыборкаПоФайлам.Операция;
			
			Если НЕ ЗначениеЗаполнено(ВыборкаПоФайлам.Ссылка) Тогда
				// Если по документу еще не создано файлов
				Если ЗначениеЗаполнено(ПоследовательностьОпераций) Тогда
					Операция = ПоследовательностьОпераций[0].Операция;
				Иначе
					Операция = Неопределено;
				КонецЕсли;
			КонецЕсли;
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Операция", Операция);
			НайденныеСтроки = ПоследовательностьОпераций.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество() = 0 Тогда
				СтрокаПоследовательности = Неопределено;
			Иначе
				СтрокаПоследовательности = НайденныеСтроки[НайденныеСтроки.Количество() - 1];
			КонецЕсли;
			
			СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы().Добавить();
			СтрокаВторогоУровня.Документ       = ВыборкаПоФайлам.Документ;
			СтрокаВторогоУровня.Файл           = ВыборкаПоФайлам.Ссылка;
			СтрокаВторогоУровня.Операция       = Операция;
			СтрокаВторогоУровня.Дата           = ВыборкаПоФайлам.ДатаСоздания;
			СтрокаВторогоУровня.Представление  = ПредставлениеОперации(СтрокаПоследовательности, ВыборкаПоФайлам.Документ, ВыборкаПоФайлам);
			СтрокаВторогоУровня.ИндексКартинки = ИнтеграцияИС.ИндексКартинкиЗапроса(СтрокаПоследовательности);
			
			Если СтрокаПоследовательности <> Неопределено
			 И СтрокаПоследовательности.ТипСообщения = Перечисления.ТипыЗапросовИС.Исходящий Тогда
				
				ВозвращаемоеЗначение = ОбработатьПередачуДанных(
					ДанныеСообщений.Найти(ВыборкаПоФайлам.Ссылка, "Запрос"),
					СтрокаВторогоУровня,
					СтрокаПоследовательности);
				
				ЕстьОшибкаСтроки   = ВозвращаемоеЗначение.Ошибка;
				ТребуетсяОжидание = ВозвращаемоеЗначение.Ожидание;
				
			Иначе
				
				ЕстьОшибкаСтроки  = ЗначениеЗаполнено(ВыборкаПоФайлам.Описание);
				ТребуетсяОжидание = Ложь;
				
			КонецЕсли;
			
			Если Не ТребуетсяОжидание И СтрокаПоследовательности <> Неопределено Тогда
				Для Каждого ДальнейшееДействие Из СтрокаПоследовательности.ДальнейшиеДействия Цикл
					СтрокаВторогоУровня.ДальнейшиеДействия.Добавить(ДальнейшееДействие);
				КонецЦикла;
			КонецЕсли;
			
			Если ЕстьОшибкаСтроки Тогда
				СтрокаВторогоУровня.ИндексКартинки = 4;
				ЕстьОшибка = Истина;
			Иначе
				СтрокаВторогоУровня.ИндексКартинки = ИнтеграцияИС.ИндексКартинкиЗапроса(СтрокаПоследовательности);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьОшибка Тогда
			СтрокаПоследовательности = ИнтеграцияВЕТИС.ПредыдущаяОперация(ПоследовательностьОпераций, СтрокаПоследовательности);
		КонецЕсли;
		
		Если СтрокаПоследовательности <> Неопределено Тогда
			
			Индекс = ПоследовательностьОпераций.Индекс(СтрокаПоследовательности);
			
			Для Итератор = Индекс + 1 По ПоследовательностьОпераций.Количество() - 1 Цикл
				
				СтрокаСледующаяОперация = ПоследовательностьОпераций.Получить(Итератор);
				Если СтрокаСледующаяОперация.Индекс = 0
					Или СтрокаПоследовательности.Индекс = СтрокаСледующаяОперация.Индекс Тогда
					
					СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы().Добавить();
					СтрокаВторогоУровня.Документ           = ВыборкаПоДокументам.Документ;
					СтрокаВторогоУровня.Операция           = СтрокаСледующаяОперация.Операция;
					СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеСерый";
					СтрокаВторогоУровня.Представление      = ПредставлениеОперации(СтрокаСледующаяОперация, СтрокаВторогоУровня.Документ, Неопределено);
					СтрокаВторогоУровня.ИндексКартинки     = ИнтеграцияИС.ИндексКартинкиЗапроса(СтрокаСледующаяОперация, Истина);
					
					Для Каждого ДальнейшееДействие Из СтрокаСледующаяОперация.ДальнейшиеДействия Цикл
						СтрокаВторогоУровня.ДальнейшиеДействия.Добавить(ДальнейшееДействие);
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоФайлов()
	
	ТекстДокументаВЕТИС = "";
	ДеревоФайлов.ПолучитьЭлементы().Очистить();
	
	Строки = Новый Массив;
	Строки.Добавить(НСтр("ru = 'Основание:'"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Документ),,,,ПолучитьНавигационнуюСсылку(Документ)));
	ТекстДокумент = Новый ФорматированнаяСтрока(Строки);
	
	ТипДокумента = ТипЗнч(Документ);
	ЭтоДокументОснование = Ложь;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеВходящаяТранспортнаяОперацияВЕТИС.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаВходящаяТранспортнаяОперацияВЕТИС(Документ);
		ЭтоДокументОснование = Истина;
		
	КонецЕсли;
		
	Если Метаданные.ОпределяемыеТипы.ОснованиеИнвентаризацияПродукцииВЕТИС.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаИнвентаризацияПродукцииВЕТИС(Документ);
		ЭтоДокументОснование = Истина;
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеИсходящаяТранспортнаяОперацияВЕТИС.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаИсходящаяТранспортнаяОперацияВЕТИС(Документ);
		ЭтоДокументОснование = Истина;
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеПроизводственнаяОперацияВЕТИС.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаПроизводственнаяОперацияВЕТИС(Документ);
		ЭтоДокументОснование = Истина;
		
	КонецЕсли;
	
	Если НЕ ЭтоДокументОснование
	 ИЛИ Метаданные.Справочники.ВЕТИСПрисоединенныеФайлы.Реквизиты.Документ.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		Строки = Новый Массив;
		Строки.Добавить(НСтр("ru = 'Документ:'"));
		Строки.Добавить(" ");
		Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Документ),,,,ПолучитьНавигационнуюСсылку(Документ)));
		ТекстДокумент = Новый ФорматированнаяСтрока(Строки);
		
		ЗаполнитьПоДокументу(ТаблицаДокументы(Документ));
		
	КонецЕсли;
	
	Элементы.ИнтеграцияВетИС_ИнформацияОДокументах.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ОбработатьПередачуДанных(СтрокаТЧ, СтрокаВторогоУровня, Последовательность)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Ошибка",   Ложь);
	ВозвращаемоеЗначение.Вставить("Ожидание", Ложь);
	
	Если СтрокаТЧ <> Неопределено И ЗначениеЗаполнено(СтрокаТЧ.ОтветНаПередачуДанных) Тогда
		
		Если ЗначениеЗаполнено(СтрокаТЧ.ОтветНаПередачуДанных)
			И СтрокаТЧ.ОтветНаПередачуДанныхСостояниеОбработки = Перечисления.СтатусыОбработкиСообщенийВЕТИС.Ошибка Тогда
			
			ВозвращаемоеЗначение.Ошибка = Истина;
			
		ИначеЕсли ЗначениеЗаполнено(СтрокаТЧ.ПолученРезультатЗапросаВЕТИС)
			И СтрокаТЧ.ПолученРезультатЗапросаВЕТИССостояниеОбработки = Перечисления.СтатусыОбработкиСообщенийВЕТИС.Ошибка Тогда
			
			ВозвращаемоеЗначение.Ошибка = Истина;
			
		ИначеЕсли ЗначениеЗаполнено(СтрокаТЧ.ОтветНаЗапросВЕТИС)
			И СтрокаТЧ.ОтветНаЗапросВЕТИССостояниеОбработки = Перечисления.СтатусыОбработкиСообщенийВЕТИС.Ошибка Тогда
			
			ВозвращаемоеЗначение.Ошибка = Истина;
			
		КонецЕсли;
		
		Если ВозвращаемоеЗначение.Ошибка Тогда
			
			СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеОшибка";
			СтрокаВторогоУровня.ИндексКартинки = 4; // Ошибка
			
		КонецЕсли;
		
	ИначеЕсли СтрокаТЧ <> Неопределено И ЗначениеЗаполнено(СтрокаТЧ.Запрос) Тогда
		
		СтрокаВторогоУровня.ИндексКартинки = 3;
		
	Иначе
		
		СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеСерый";
		СтрокаВторогоУровня.ИндексКартинки = 7;
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияВЕТИСКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
