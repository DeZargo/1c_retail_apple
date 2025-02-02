﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработатьСозданиеНовогоЭлемента(Результат, ПараметрыВыполнения) Экспорт
	Если Результат = Неопределено ИЛИ НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСозданияНовогоЭлемента() Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрВладелец", ВладелецСоздаваемоегоЭлемента);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОбработатьСозданиеНовогоЭлемента", ЭтотОбъект);
	
	РежимОткрытия = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.Форма.ФормаЭлемента",
					ПараметрыФормы,УникальныйИдентификатор,,,,
					ОбработчикОповещения,
					РежимОткрытия);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ЗначениеИзСтруктуры;
	
	Если Параметры.Свойство("ПараметрВладелец", ЗначениеИзСтруктуры) И ЗначениеЗаполнено(ЗначениеИзСтруктуры) Тогда
		
		Если ТипЗнч(ЗначениеИзСтруктуры) = Тип("СправочникСсылка.Номенклатура") Тогда
			ВладелецХарактеристики = Неопределено;
			Если ОбработкаТабличнойЧастиТоварыВызовСервера.ПроверитьИспользованиеХарактеристикИПолучитьВладельцаДляВыбора(ЗначениеИзСтруктуры, ВладелецХарактеристики) Тогда
				Если НЕ ВладелецХарактеристики = Неопределено Тогда
					Параметры.ПараметрВладелец = ВладелецХарактеристики;
					Параметры.Свойство("ПараметрВладелец", ЗначениеИзСтруктуры);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Параметры.Отбор.Вставить("Владелец", ЗначениеИзСтруктуры);
		ВладелецСоздаваемоегоЭлемента = ЗначениеИзСтруктуры;
		
	ИначеЕсли Параметры.Свойство("Номенклатура", ЗначениеИзСтруктуры) И ЗначениеЗаполнено(ЗначениеИзСтруктуры) Тогда
		
		Если ТипЗнч(ЗначениеИзСтруктуры) = Тип("СправочникСсылка.Номенклатура") Тогда
			ВладелецХарактеристики = Неопределено;
			Если ОбработкаТабличнойЧастиТоварыВызовСервера.ПроверитьИспользованиеХарактеристикИПолучитьВладельцаДляВыбора(ЗначениеИзСтруктуры, ВладелецХарактеристики) Тогда
				Если НЕ ВладелецХарактеристики = Неопределено Тогда
					Параметры.Отбор.Вставить("Владелец", ВладелецХарактеристики);
					ВладелецСоздаваемоегоЭлемента = ВладелецХарактеристики;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущийЭлемент", ЗначениеИзСтруктуры) Тогда
		НачальныйЭлемент = ЗначениеИзСтруктуры;
	КонецЕсли;
	
	Если Параметры.Свойство("ОткрытьСозданиеНовойХарактеристики") Тогда
		ОткрытьСозданиеНовойХарактеристики = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЗначениеЗаполнено(НачальныйЭлемент) Тогда
		Элементы.Список.ТекущаяСтрока = НачальныйЭлемент;
	КонецЕсли;
	
	
	Если ОткрытьСозданиеНовойХарактеристики Тогда
		ПодключитьОбработчикОжидания("ОткрытьФормуСозданияНовогоЭлемента", 0.1, Истина);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти