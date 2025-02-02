﻿
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьОтборПоАкцииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Отчет.МаркетинговаяАкция = Результат;
		ПриИзмененииМаркетинговойАкцииСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	Отчет.Диаграмма = Найти(ВРЕГ(НаименованиеТекущегоВарианта), "ДИАГРАММА") > 0;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	Перем АдресХранилищаНастроекДляРасшифровки;
	
	Если Параметры.Свойство("ЭтоРасшифровка") Тогда
		
		Параметры.Свойство("Интервал"          , Отчет.Интервал);
		Параметры.Свойство("МаркетинговаяАкция", Отчет.МаркетинговаяАкция);
		
		Если Параметры.Свойство("АдресХранилищаНастроекДляРасшифровки", АдресХранилищаНастроекДляРасшифровки) Тогда
			
			НастройкаРасшифровки = ПолучитьИзВременногоХранилища(АдресХранилищаНастроекДляРасшифровки);
			МаркетинговыеАкцииСервер.ЗаполнитьОтборПоОтбору(Отчет.КомпоновщикНастроек, НастройкаРасшифровки.Отбор);
			МаркетинговыеАкцииСервер.ЗаполнитьПараметрыКомпоновщика(Отчет.КомпоновщикНастроек, НастройкаРасшифровки.ПараметрыДанных);
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Отчет.МаркетинговаяАкция) Тогда
		
		ПриИзмененииМаркетинговойАкцииСервер();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	ВариантыОтчетов.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьОтборПоАкции(Команда)
    
    // &ЗамерПроизводительности
    ОценкаПроизводительностиРТКлиент.НачатьЗамер(
             Истина, "Документ.МаркетинговаяАкция.Форма.ФормаВыбора.Открытие");	
             
	ДополнительныеПараметры = Новый Структура;
	ОбработчикОповещения = Новый ОписаниеОповещения("ЗаполнитьОтборПоАкцииЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Документ.МаркетинговаяАкция.ФормаВыбора", , ЭтаФорма, , , , ОбработчикОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзмененииМаркетинговойАкцииСервер()
	Перем НачалоПериода, КонецПериода;
	
	Если ЗначениеЗаполнено(Отчет.МаркетинговаяАкция) Тогда
		ДатаНачалаАкции = Отчет.МаркетинговаяАкция.ДатаНачалаДействия;
		ДатаКонцаАкции  = Отчет.МаркетинговаяАкция.ДатаОкончанияДействия;
		Если Не ЗначениеЗаполнено(ДатаКонцаАкции)  Тогда
			ДатаКонцаАкции = КонецДня(ТекущаяДатаСеанса());
		КонецЕсли;
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(ДатаКонцаАкции) И ЗначениеЗаполнено(ДатаНачалаАкции) И ДатаКонцаАкции >= ДатаНачалаАкции Тогда
		Если НачалоМесяца(ДатаНачалаАкции) = ДатаНачалаАкции
			И КонецМесяца(ДатаКонцаАкции) = КонецДня(ДатаКонцаАкции) Тогда
			КоличествоМесяцев = Год(ДатаКонцаАкции) * 12 + Месяц(ДатаКонцаАкции) - Год(ДатаНачалаАкции) * 12 - Месяц(ДатаНачалаАкции) + 1;
			НачалоПериода     = ДобавитьМесяц(ДатаНачалаАкции, - КоличествоМесяцев);
			КонецПериода      = ДобавитьМесяц(ДатаКонцаАкции , КоличествоМесяцев);
		Иначе
			КоличествоСекунд = (КонецДня(ДатаКонцаАкции) - ДатаНачалаАкции+1);
			НачалоПериода    = ДатаНачалаАкции - КоличествоСекунд;
			КонецПериода     = ДатаКонцаАкции  + КоличествоСекунд;
		КонецЕсли;
	Иначе
		КонецПериода  = ДатаКонцаАкции;
		НачалоПериода = ДатаНачалаАкции;
	КонецЕсли;
	
	Периоды = Новый Структура;
	Периоды.Вставить("НачалоПериода"  , НачалоПериода);
	Периоды.Вставить("КонецПериода"   , КонецПериода);
	
	МаркетинговыеАкцииСервер.УстановитьОтборСегментовПоМаркетинговойАкции(Отчет.КомпоновщикНастроек, Отчет.МаркетинговаяАкция, Периоды);
	
КонецПроцедуры

#КонецОбласти
