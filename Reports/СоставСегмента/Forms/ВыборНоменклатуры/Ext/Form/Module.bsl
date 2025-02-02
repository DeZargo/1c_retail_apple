﻿
#Область ПеременныеФормы

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработатьСозданиеИВыборНовойХарактеристики(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Характеристика = Результат;

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбработкаТабличнойЧастиТоварыКлиент.ВыбратьХарактеристикуНоменклатуры(ЭтаФорма, Элемент, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Характеристика);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Характеристика);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(Неопределено, СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;

КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", Номенклатура);
	ТекущаяСтрока.Вставить("Характеристика", Характеристика);
	ТекущаяСтрока.Вставить("ИдентификаторТекущейСтроки", 0);
	
	ОбработкаТабличнойЧастиТоварыКлиент.СоздатьХарактеристикуНоменклатуры(ЭтотОбъект, Элемент, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)

	Если Номенклатура.Пустая() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Нстр("ru= 'Не указана номенклатура.'"),
		                                                  ,
		                                                  "Номенклатура");
		Возврат;
	КонецЕсли;
	
	Если ХарактеристикиИспользуются И Характеристика.Пустая() Тогда
	
		ОбщегоНазначенияКлиент.СообщитьПользователю(Нстр("ru= 'Не указана характеристика.'"),
		                                                  ,
		                                                  "Характеристика");
		Возврат;
	
	КонецЕсли;
	
	Закрыть(Новый Структура("Номенклатура, Характеристика", Номенклатура, Характеристика));

КонецПроцедуры

#КонецОбласти
