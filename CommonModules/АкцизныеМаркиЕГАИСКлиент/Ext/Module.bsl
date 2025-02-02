﻿
#Область СлужебныеПроцедурыИФункции

Процедура ПредставлениеСохраненногоВыбораОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки) Экспорт
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СброситьСохраненныеДанныеВыбораПоМаркируемойПродукции" Тогда
		
		Форма.СохраненВыборПоМаркируемойПродукции = Ложь;
		Форма.ДанныеВыбораПоМаркируемойПродукции  = Неопределено;
		ШтрихкодированиеИСКлиентСервер.ОтобразитьСохраненныйВыборПоМаркируемойПродукции(Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьАлкогольнуюПродукцию" Тогда
		
		ПоказатьЗначение(, Форма.ДанныеВыбораПоМаркируемойПродукции.АлкогольнаяПродукция);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьНоменклатуру" Тогда
		
		ПоказатьЗначение(, Форма.ДанныеВыбораПоМаркируемойПродукции.Номенклатура);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьХарактеристику" Тогда
		
		ПоказатьЗначение(, Форма.ДанныеВыбораПоМаркируемойПродукции.Характеристика);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьСерию" Тогда
		
		ПоказатьЗначение(, Форма.ДанныеВыбораПоМаркируемойПродукции.Серия);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ДанныеОПроблеме) Экспорт
	
	Если ТипЗнч(ДанныеОПроблеме) = Тип("Структура") Тогда
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ДанныеШтрихкода", ДанныеОПроблеме);
	Иначе
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресХранилищаДереваУпаковки", ДанныеОПроблеме);
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС.Форма.ИнформацияОНевозможностиДобавленияОтсканированного",
		ПараметрыОткрытияФормы,
		Форма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти