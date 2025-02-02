﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем МассивСерийныхНомеров;
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("МассивСерийныхНомеров", МассивСерийныхНомеров) Тогда
	
		Отказ = Истина;
	
	КонецЕсли;
	
	ЗаполнитьТаблицуЗначенийФормы(МассивСерийныхНомеров);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСерийныеНомера

&НаКлиенте
Процедура СерийныеНомераВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыбор(СерийныеНомера[ВыбраннаяСтрока]);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСерийныйНомер(Команда)
	
	ТекущаяСтрока = Элементы.СерийныеНомера.ТекущиеДанные;
	
	ОбработатьВыбор(ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуЗначенийФормы(МассивСерийныхНомеров)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СерийныеНомера.Ссылка
	|ПОМЕСТИТЬ ТаблицаЗапроса
	|ИЗ
	|	Справочник.СерийныеНомера КАК СерийныеНомера
	|ГДЕ
	|	СерийныеНомера.Ссылка В(&МассивСерийныхНомеров)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапроса.Ссылка КАК СерийныйНомер,
	|	ЕСТЬNULL(Штрихкоды.Штрихкод, """") КАК ШтрихКод,
	|	ВЫБОР
	|		КОГДА ТаблицаЗапроса.Ссылка.Владелец.ТипСерийногоНомера = ЗНАЧЕНИЕ(Перечисление.ТипыСерийныхНомеровСертификатов.Смешанный)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоСмешаннаяКарта
	|ИЗ
	|	ТаблицаЗапроса КАК ТаблицаЗапроса
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	|		ПО ТаблицаЗапроса.Ссылка = Штрихкоды.Владелец";
	
	Запрос.УстановитьПараметр("МассивСерийныхНомеров", МассивСерийныхНомеров);
	
	Результат = Запрос.Выполнить();
	ТаблицаЗапроса = Результат.Выгрузить();
	
	СерийныеНомера.Загрузить(ТаблицаЗапроса);
	
	Элементы.СерийныеНомераШтрихкод.Видимость = ТаблицаЗапроса.НайтиСтроки(Новый Структура("ЭтоСмешаннаяКарта", Истина)).Количество() > 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыбор(ТекущаяСтрока)

	Если Не ТекущаяСтрока = Неопределено Тогда
	
		СерийныйНомер = ТекущаяСтрока.СерийныйНомер;
		ДанныеОСерийномНомере = МаркетинговыеАкцииВызовСервера.ПолучитьДанныеПодарочногоСертификата(СерийныйНомер);
		Закрыть(ДанныеОСерийномНомере);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
