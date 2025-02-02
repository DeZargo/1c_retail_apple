﻿
Функция ПроверитьЕстьЛиТакаяАкцизнаяМаркаВНакладной(Марка)
	//Древо=ДеревоМаркированнойПродукции.ПолучитьЭлементы(,,Истина);
	Древо=ДанныеФормыВЗначение(ДеревоМаркированнойПродукции,Тип("ДеревоЗначений"));
	строка=Древо.Строки.Найти(Марка,,Истина);
	//Если ЗначениеЗАполнено(строка) и строка.СтатусПроверки<>Перечисления.СтатусыПроверкиНаличияАлкогольнойПродукции.НеПроверялась Тогда
	Если ЗначениеЗАполнено(строка) и строка.СтатусПроверки<>Перечисления.СтатусыПроверкиНаличияПродукцииИС.НеПроверялась Тогда	
		возврат Истина
	КонецЕсли;
	Возврат ложь;
КонецФункции

&НаКлиенте
&Вместо("РучнойВводШтрихкодаЗавершение")
Процедура КочетовРучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры)
	//	Если СтрДлина(ДанныеШтрихкода.Штрихкод)<50 Тогда
	//		Сообщить("Нельзя считывать не акцизную марку!");
	//		возврат;
	//	КонецЕСли;
	ДанныеШтрихкода.Штрихкод = ОбработатьРусскиеБуквы(ДанныеШтрихкода.Штрихкод);
	Если ПроверитьЕстьЛиТакаяАкцизнаяМаркаВНакладной(ДанныеШтрихкода.Штрихкод) Тогда
		Сообщить("Нельзя считывать одну и ту же акцизную марку дважды!");
		возврат;
	КонецЕСли;
	//до обновления:
	//ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект, ДополнительныеПараметры),
	//                                                   ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканированияАкцизныхМарок());
	//после обновления:
	ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект, ДополнительныеПараметры),
	ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования());													   
КонецПроцедуры

//&НаКлиенте
//&Перед("РучнойВводШтрихкодаЗавершение")
//Процедура КочетовРучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры)
//	
//	ДанныеШтрихкода.Штрихкод=ОбработатьРусскиеБуквы(ДанныеШтрихкода.Штрихкод); //ValMa
//	
//КонецПроцедуры

Функция ОбработатьРусскиеБуквы(Марка)
	
	Ном=ВРЕГ(Марка);
	Ном=СтрЗаменить(Ном,"Й","Q");
	Ном=СтрЗаменить(Ном,"Ц","W");
	Ном=СтрЗаменить(Ном,"У","E");
	Ном=СтрЗаменить(Ном,"К","R");
	Ном=СтрЗаменить(Ном,"Е","T");
	Ном=СтрЗаменить(Ном,"Н","Y");
	Ном=СтрЗаменить(Ном,"Г","U");
	Ном=СтрЗаменить(Ном,"Ш","I");
	Ном=СтрЗаменить(Ном,"Щ","O");
	Ном=СтрЗаменить(Ном,"З","P");
	Ном=СтрЗаменить(Ном,"Ф","A");
	Ном=СтрЗаменить(Ном,"Ы","S");
	Ном=СтрЗаменить(Ном,"В","D");
	Ном=СтрЗаменить(Ном,"А","F");
	Ном=СтрЗаменить(Ном,"П","G");
	Ном=СтрЗаменить(Ном,"Р","H");
	Ном=СтрЗаменить(Ном,"О","J");
	Ном=СтрЗаменить(Ном,"Л","K");
	Ном=СтрЗаменить(Ном,"Д","L");
	Ном=СтрЗаменить(Ном,"Я","Z");
	Ном=СтрЗаменить(Ном,"Ч","X");
	Ном=СтрЗаменить(Ном,"С","C");
	Ном=СтрЗаменить(Ном,"М","V");
	Ном=СтрЗаменить(Ном,"И","B");
	Ном=СтрЗаменить(Ном,"Т","N");
	Ном=СтрЗаменить(Ном,"Ь","M");
	Ном=СтрЗаменить(Ном,"!","1");
	Ном=СтрЗаменить(Ном,"""","2");
	Ном=СтрЗаменить(Ном,"№","3");
	Ном=СтрЗаменить(Ном,"$","4");
	Ном=СтрЗаменить(Ном,"%","5");
	Ном=СтрЗаменить(Ном,"^","6");
	Ном=СтрЗаменить(Ном,"&","7");
	Ном=СтрЗаменить(Ном,"*","8");
	Ном=СтрЗаменить(Ном,"(","9");
	Ном=СтрЗаменить(Ном,")","0");
	Ном=СтрЗаменить(Ном,"@","2");
	Ном=СтрЗаменить(Ном,"#","3");
	Ном=СтрЗаменить(Ном,";","4");
	Ном=СтрЗаменить(Ном,":","6");
	Ном=СтрЗаменить(Ном,"?","7");

	Возврат Ном;
	
КонецФункции

&НаКлиенте
&После("ПоискПоШтрихкодуЗавершение")
Процедура КочетовПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры)
	ПоискПоШтрихкодуВыполнить("");
	
	//ЗаполнитьВспомогательныеТаблицыПоДаннымДокумента();
	//ЗагрузитьАлкогольнуюПродукцию();
	//УправлениеЭлементамиФормыПриСоздании();

	//ПересчитатьВсеИтогиФормы()
//	ЭтотОбъект.ОбновитьОтображениеДанных();
//	Элементы.ДеревоМаркированнойПродукции.Развернуть();
	//йцу();
	//ОбновитьИнтерфейс();
	//ЭтотОбъект.ОбновитьОтображениеДанных();
	//Элементы.ДеревоМаркированнойПродукции.Обновить();
	//Элементы.ДеревоМаркированнойПродукции.Развернуть(1);
	//ЭтотОбъект.ОбновитьОтображениеДанных();
	//ЭтаФорма.ОбновитьОтображениеДанных(
	
	//Элементы.ДеревоМаркированнойПродукции.
КонецПроцедуры


процедура йцу()
//	ЭтаФорма.прочитать();
	//Элементы.
	
	//Древо=ДанныеФормыВЗначение(ДеревоМаркированнойПродукции,Тип("ДеревоЗначений"));
//	
//	йц=Древо.строки.добавить();
	
	//ЗначениеВДанныеФормы(Древо,ДеревоМаркированнойПродукции);

КонецПроцедуры
//&НаКлиенте
//&Вместо("ПроверитьШтрихкодВТаблицеНеМаркированнойПродукции")
//Процедура КочетовПроверитьШтрихкодВТаблицеНеМаркированнойПродукции(ДанныеШтрихкода, ШтрихкодОбработан,йцу)
//	Если ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417")  Тогда

//	//	Или ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
//		
//		Возврат;
//	Иначе
//		Сообщить("Считыванию подлежит только Акцизная марка!");
//	КонецЕсли;
//КонецПроцедуры


&НаКлиенте
Процедура УдалитьПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("УдалитьРучнойВводШтрихкодаЗавершение", ЭтотОбъект));
	
КонецПроцедуры
		
&НаКлиенте
Процедура УдалитьРучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(ДанныеШтрихкода) Тогда
		древо=ДеревоМаркированнойПродукции.получитьЭлементы();
		струк=Новый Структура;
		Струк.Вставить("ЗначениеШтрихкода",ДанныеШтрихкода.ШтрихКод);
		ДанныеФормыКоллекцияЭлементовДереваНайтиСтроки(древо,Струк,Истина);
	КонецЕсли;
	//АкцизныеМаркиЕГАИСКлиент.ОбработатьДанныеШтрихкода(Новый ОписаниеОповещения("КочетовУдалитьПоискПоШтрихкодуЗавершение", ЭтотОбъект),
	//                                                   ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканированияАкцизныхМарок());
	
КонецПроцедуры


&НаКлиенте
Функция ДанныеФормыКоллекцияЭлементовДереваНайтиСтроки(КоллекцияСтрок, ПараметрыОтбора, ВключатьПодчиненные = Ложь) Экспорт
	Результат = Новый Массив;
	Для Каждого СтрокаТекущая Из КоллекцияСтрок Цикл
		СтрокаНайдена = Истина;
		Для Каждого КлючИЗначение Из ПараметрыОтбора Цикл
			Если СтрокаТекущая[КлючИЗначение.Ключ] <> КлючИЗначение.Значение Тогда
				СтрокаНайдена = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если СтрокаНайдена Тогда
			КоллекцияСтрок.удалить(КоллекцияСтрок.Индекс(СтрокаТекущая));
			//Результат.Добавить(СтрокаТекущая);
		КонецЕсли;
		Если ВключатьПодчиненные Тогда
			ПодчиненныеСтроки = ДанныеФормыКоллекцияЭлементовДереваНайтиСтроки(СтрокаТекущая.ПолучитьЭлементы(), ПараметрыОтбора, ВключатьПодчиненные);
			//Для Каждого НайденнаяСтрока Из ПодчиненныеСтроки Цикл
			//	Результат.Добавить(НайденнаяСтрока);
			//КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	//Возврат Результат;
КонецФункции

Процедура УдалитьРучнойВводШтрихкодаЗавершениеСервер(Штрихкод)
	
	//Древо=ДанныеФормыВЗначение(ДеревоМаркированнойПродукции,Тип("ДеревоЗначений"));
	//стр=Древо.Строки.найти(Штрихкод,,Истина);
	//
	//Если стр<>Неопределено тогда
	//	
	//	//ДеревоМаркированнойПродукции.получитьЭлементы()
	//	ДеревоМаркированнойПродукции.НайтиПоИдентификатору(стр.ПолучитьИдентификатор())
	//	стр.Родитель.Строки.Удалить(Стр);	
	//КонецЕсли;
	//
	//ЗначениеВДанныеФормы(Древо,"ДеревоМаркированнойПродукции");
	//
КонецПроцедуры



&НаКлиенте
Процедура КочетовУдалитьПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры)
	УдалитьПоискПоШтрихкодуВыполнить("");
КонецПроцедуры

&НаСервере
Процедура КочетовПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	//древо=ДанныеФормыВЗначение(ДеревоМаркированнойПродукции,Тип("ДеревоЗначений"));
	//
	//Для каждого стр из древо.Строки цикл

	//	Если стр.ТипУпаковки=Перечисления.ТипыУпаковок.МонотоварнаяУпаковка 
	//			или стр.ТипУпаковки=Перечисления.ТипыУпаковок.МультитоварнаяУпаковка Тогда	
	//			
	//				стр.СтатусПроверки=Перечисления.СтатусыПроверкиНаличияАлкогольнойПродукции.ВНаличии
	//	КонецЕсли;	
	//	
	//КонецЦикла;
	//
	//ЗначениеВДанныеФормы(древо,ДеревоМаркированнойПродукции);
	
	Если рольДоступна("ПолныеПрава") Тогда
		элементы.ПодменюСтатусПроверки.Видимость=Истина;
	Иначе
		элементы.ПодменюСтатусПроверки.Видимость=Ложь;
	КонецЕсли;

	
КонецПроцедуры

//&НаКлиенте
//&Вместо("ПослеУспешногоОбнаруженияОтсканированногоШтрихкодаВДереве")
//Процедура КочетовПослеУспешногоОбнаруженияОтсканированногоШтрихкодаВДереве(НайденнаяСтрокаДерева, ТекущаяСтрокаДерева, РодительНайденнойСтроки, ТребуетсяОткрытиеФормыВыбораДействия, ТипУпаковкиГдеНашли, ОбработкаДанныхТСД)
//	Если ИнтеграцияЕГАИСКлиентСервер.ЭтоУпаковка(НайденнаяСтрокаДерева.ТипУпаковки) Тогда
//		
//		Если ДетализацияСтруктурыХранения = ПредопределенноеЗначение("Перечисление.ДетализацияСтруктурыХраненияАлкогольнойПродукции.Бутылки") Тогда
//			Возврат;
//		КонецЕсли;
//		
//		Если ОбработкаДанныхТСД Тогда
//			
//			Если ЗагрузкаДанныхТСД.ТекущаяОперация = "ЕдинственнаяУпаковка" Тогда
//				
//				ЗагрузкаДанныхТСД.ИдентификаторУпаковки = НайденнаяСтрокаДерева.ПолучитьИдентификатор();
//				ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//				
//				Если НайденнаяСтрокаДерева.ПолучитьРодителя() = Неопределено Тогда
//					ОтметитьСтрокуКакНайденную(НайденнаяСтрокаДерева);
//				КонецЕсли;
//				Возврат;
//				
//			Иначе
//				
//				СтрокаПроверяемойУпаковки = СтрокаТекущейПроверяемойУпаковкиТСД(ЭтотОбъект, Истина);
//				
//			КонецЕсли;
//			
//		Иначе
//			СтрокаПроверяемойУпаковки = СтрокаТекущейПроверяемойУпаковки(ЭтотОбъект, Истина);
//		КонецЕсли;
//		
//		Если НайденнаяСтрокаДерева.ИдетПроверкаДаннойУпаковки
//			И Не ОбработкаДанныхТСД Тогда
//			
//			СнятьПризнакПроверкиУпаковки(НайденнаяСтрокаДерева);
//			СпозиционироватьсяНаСтрокеДерева(ЭтотОбъект, НайденнаяСтрокаДерева);
//			ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//			
//		ИначеЕсли РодительНайденнойСтроки = СтрокаПроверяемойУпаковки Тогда
//		
//			Если НайденнаяСтрокаДерева = ТекущаяСтрокаДерева
//				И Не ОбработкаДанныхТСД Тогда
//			
//				ОтметитьСтрокуКакНайденную(НайденнаяСтрокаДерева);
//				ИзменитьСостояниеПроверкиУпаковки(НайденнаяСтрокаДерева);
//				ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//				
//			Иначе
//				
//				ОтметитьСтрокуКакНайденную(НайденнаяСтрокаДерева);
//				СпозиционироватьсяНаСтрокеДерева(ЭтотОбъект, НайденнаяСтрокаДерева);
//				ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//				
//			КонецЕсли;
//			
//		ИначеЕсли ДетализацияСтруктурыХранения = ПредопределенноеЗначение("Перечисление.ДетализацияСтруктурыХраненияАлкогольнойПродукции.КоробаСБутылками")
//			И СтрокаПроверяемойУпаковки <> Неопределено Тогда

//			ОтметитьСтрокуКакНайденную(НайденнаяСтрокаДерева);
//			СнятьПризнакПроверкиУпаковки(СтрокаПроверяемойУпаковки);
//			СпозиционироватьсяНаСтрокеДерева(ЭтотОбъект, НайденнаяСтрокаДерева);
//			
//			ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//			
//		ИначеЕсли ОбработкаДанныхТСД 
//			И ЗагрузкаДанныхТСД.ТекущаяОперация = "Упаковка"
//			//И РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейАлкогольнойПродукции.ОставлятьТамГдеНайдены") Тогда
//			И РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
//			ПереместитьУпаковкуВДругуюУпаковку(НайденнаяСтрокаДерева, СтрокаПроверяемойУпаковки);
//			ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//			
//		КонецЕсли;
//		
//	Иначе
//		
//		Если ОбработкаДанныхТСД Тогда
//			СтрокаПроверяемойУпаковки = СтрокаТекущейПроверяемойУпаковкиТСД(ЭтотОбъект, Ложь);
//			ИдентификаторУпаковки = ЗагрузкаДанныхТСД.ИдентификаторУпаковки;
//		Иначе
//			СтрокаПроверяемойУпаковки = СтрокаТекущейПроверяемойУпаковки(ЭтотОбъект, Ложь);
//			ИдентификаторУпаковки = ИдентификаторТекущейПроверяемойУпаковки;
//		КонецЕсли;
//		
//		Если //(РодительНайденнойСтроки = Неопределено 
//		//	Или РодительНайденнойСтроки.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ПрочиеЗоныПересчетаАлкогольнойПродукции.БутылкиБезКоробки"))
//		//	И 
//			ИдентификаторУпаковки = -1 Тогда
//			
//			ОтметитьСтрокуКакНайденную(НайденнаяСтрокаДерева);
//			СпозиционироватьсяНаСтрокеДерева(ЭтотОбъект, НайденнаяСтрокаДерева);
//			ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//		
//		ИначеЕсли РодительНайденнойСтроки.ПолучитьИдентификатор() = ИдентификаторУпаковки Тогда
//			
//			ОтметитьСтрокуКакНайденную(НайденнаяСтрокаДерева);
//			СпозиционироватьсяНаСтрокеДерева(ЭтотОбъект, НайденнаяСтрокаДерева);
//			ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//			
//		ИначеЕсли ОбработкаДанныхТСД 
//			//И РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейАлкогольнойПродукции.ОставлятьТамГдеНайдены") Тогда
//			И РежимПроверки = ПредопределенноеЗначение("Перечисление.ВариантыПроверкиПоступившейПродукцииИС.ОставлятьТамГдеНайдены") Тогда
//			ПереместитьБутылку(НайденнаяСтрокаДерева, СтрокаПроверяемойУпаковки);
//			ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//			
//		Иначе
//			
//			Если (РодительНайденнойСтроки.НеСодержитсяВДанныхДокумента
//				Или РодительНайденнойСтроки.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ПрочиеЗоныПересчетаАлкогольнойПродукции.БутылкиБезКоробки"))
//				И (СтрокаПроверяемойУпаковки.НеСодержитсяВДанныхДокумента
//				Или СтрокаПроверяемойУпаковки.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ПрочиеЗоныПересчетаАлкогольнойПродукции.БутылкиБезКоробки")) Тогда
//				
//				ОтметитьСтрокуКакНайденную(НайденнаяСтрокаДерева);
//				ПереместитьБутылку(НайденнаяСтрокаДерева, СтрокаПроверяемойУпаковки);
//				ТребуетсяОткрытиеФормыВыбораДействия = Ложь;
//				
//			КонецЕсли;
//			
//		КонецЕсли;
//		
//	КонецЕсли;
//	
//	Если СтрокаПроверяемойУпаковки <> Неопределено Тогда
//		ТипУпаковкиГдеНашли = СтрокаПроверяемойУпаковки.ТипУпаковки;
//	КонецЕсли;

//КонецПроцедуры

&НаКлиенте
Процедура КочетовПроверкаЗавершенаПеред(Команда)
	КочетовПроверкаЗавершенаПередСервер()
КонецПроцедуры



Процедура КочетовПроверкаЗавершенаПередСервер()
	
		
	древо=ДанныеФормыВЗначение(ДеревоМаркированнойПродукции,Тип("ДеревоЗначений"));
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипУпаковки", Перечисления.ТипыУпаковок.МонотоварнаяУпаковка);	
	НайденныеСтроки=древо.Строки.НайтиСтроки(ПараметрыОтбора,истина);
	
	Для каждого стр из НайденныеСтроки цикл
		//стр.СтатусПроверки=Перечисления.СтатусыПроверкиНаличияАлкогольнойПродукции.ВНаличии
		стр.СтатусПроверки=Перечисления.СтатусыПроверкиНаличияПродукцииИС.ВНаличии
	КонецЦикла;
	//
	//ПараметрыОтбора = Новый Структура;
	//ПараметрыОтбора.Вставить("ТипУпаковки", Перечисления.ТипыУпаковок.МультитоварнаяУпаковка);	
	//НайденныеСтроки=древо.Строки.НайтиСтроки(ПараметрыОтбора,истина);
	//
	//Для каждого стр из НайденныеСтроки цикл
	//	стр.СтатусПроверки=Перечисления.СтатусыПроверкиНаличияАлкогольнойПродукции.ВНаличии
	//КонецЦикла;

	
	ЗначениеВДанныеФормы(древо,ДеревоМаркированнойПродукции);

КонецПроцедуры

&НаКлиенте
Процедура КочетовПриОткрытииПосле(Отказ)
	//Элементы.СтраницаМаркируемая.Видимость = истина;
	//Элементы.СтраницаНеМаркируемая.Видимость = истина;
КонецПроцедуры

//&НаКлиенте
//Функция ПараметрыСканированияАкцизныхМарок()
//	
//	ПараметрыСканированияАкцизныхМарок = АкцизныеМаркиКлиентСерверПараметрыСканированияАкцизныхМарок(ВладелецФормы);
//	ПараметрыСканированияАкцизныхМарок.СоздаватьШтрихкодУпаковки                      = Ложь;
//	ПараметрыСканированияАкцизныхМарок.АдресСоответствияАкцизныхМарок                 = Неопределено;
//	ПараметрыСканированияАкцизныхМарок.ЗапрашиватьНоменклатуру                        = РежимПодбораСуществующихУпаковок;
//	ПараметрыСканированияАкцизныхМарок.ДанныеВыбораПоАлкогольнойПродукции             = ДанныеВыбораПоМаркируемойПродукции;
//	ПараметрыСканированияАкцизныхМарок.ИспользуютсяДанныеВыбораПоАлкогольнойПродукции = Истина;
//	ПараметрыСканированияАкцизныхМарок.ВозможнаЗагрузкаТСД                            = Истина;
//	ПараметрыСканированияАкцизныхМарок.СоответствиеШтрихкодовСтрокДерева              = СоответствиеШтрихкодовСтрокДерева;
//	
//	Возврат ПараметрыСканированияАкцизныхМарок;
//	
//КонецФункции

//// Возвращает структуру параметров сканирования акцизных марок.
////
//Функция АкцизныеМаркиКлиентСерверПараметрыСканированияАкцизныхМарок(Форма, ФормаВыбора = Неопределено) Экспорт
//	
//	Если ФормаВыбора = Неопределено Тогда
//		ФормаВыбора = Форма;
//	КонецЕсли;
//	
//	Результат = Новый Структура;
//	Результат.Вставить("ИдентификаторСтроки");
//	Результат.Вставить("АдресВоВременномХранилище",                      "");
//	Результат.Вставить("АдресСоответствияАкцизныхМарок",                 Неопределено);
//	Результат.Вставить("АдресДанныхДокументаОснования" ,                 Неопределено);
//	Результат.Вставить("ДокументОснование",                              Неопределено);
//	Результат.Вставить("ДокументЕГАИС",                                  Неопределено);
//	Результат.Вставить("ДоступныеСтатусы",                               Новый Массив);
//	Результат.Вставить("ЗапрашиватьНоменклатуру",                        Истина);
//	Результат.Вставить("КонтрольАкцизныхМарок",                          Ложь);
//	Результат.Вставить("ЗапретитьАкцизныеМаркиDataMatrixБезСтатуса",     Истина);
//	Результат.Вставить("Операция",                                       Неопределено);
//	Результат.Вставить("ОперацияКонтроляАкцизныхМарок",                  "");
//	Результат.Вставить("ОрганизацияЕГАИС",                               Неопределено);
//	Результат.Вставить("СоздаватьШтрихкодУпаковки",                      Ложь);
//	Результат.Вставить("КлючевыеРеквизиты",                              Новый Массив);
//	Результат.Вставить("ДанныеВыбораПоАлкогольнойПродукции",             Неопределено);
//	Результат.Вставить("ИспользуютсяДанныеВыбораПоАлкогольнойПродукции", Ложь);
//	Результат.Вставить("ВыполнятьКонтрольЗаполненияДляDataMatrix",       Истина);
//	Результат.Вставить("ИдентификаторФормы",                             Истина);
//	Результат.Вставить("ВозможнаЗагрузкаТСД",                            Ложь);
//	Результат.Вставить("СоответствиеШтрихкодовСтрокДерева",              Неопределено);
//	Результат.Вставить("Номенклатура",                                   Неопределено);
//	Результат.Вставить("Характеристика",                                 Неопределено);
//	Результат.Вставить("Серия",                                          Неопределено);
//	Результат.Вставить("АлкогольнаяПродукция",                           Неопределено);
//	
//	Результат.ИдентификаторФормы = Форма.УникальныйИдентификатор;
//	
//	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "АдресСоответствияАкцизныхМарок") Тогда
//		Результат.АдресСоответствияАкцизныхМарок = Форма.АдресСоответствияАкцизныхМарок;
//	КонецЕсли;
//	
//	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "АдресДанныхДокументаОснования") Тогда
//		Результат.АдресДанныхДокументаОснования = Форма.АдресДанныхДокументаОснования;
//	КонецЕсли;
//	
//	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ФормаВыбора, "Номенклатура") Тогда
//		Результат.Номенклатура = ФормаВыбора.Номенклатура;
//	КонецЕсли;
//	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ФормаВыбора, "Характеристика") Тогда
//		Результат.Характеристика = ФормаВыбора.Характеристика;
//	КонецЕсли;
//	
//	Если СтрНачинаетсяС(Форма.ИмяФормы, "Документ.АктПостановкиНаБалансЕГАИС") Тогда
//		
//		Если Форма.Объект.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3") Тогда
//			Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.КПостановкеНаБаланс"));
//		КонецЕсли;
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Отсутствует"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
//		
//		Результат.КонтрольАкцизныхМарок                          = Истина;
//		Результат.Операция                                       = Форма.Объект.ВидДокумента;
//		Результат.ДокументОснование                              = Форма.Объект.ДокументОснование;
//		Результат.ДокументЕГАИС                                  = Форма.Объект.Ссылка;
//		Результат.ОперацияКонтроляАкцизныхМарок                  = "АктПостановкиНаБаланс";
//		Результат.ОрганизацияЕГАИС                               = Форма.Объект.ОрганизацияЕГАИС;
//		Результат.СоздаватьШтрихкодУпаковки                      = Форма.Объект.ВидДокумента <> ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2");
//		Результат.ДанныеВыбораПоАлкогольнойПродукции             = Форма.ДанныеВыбораПоАлкогольнойПродукции;
//		Результат.ИспользуютсяДанныеВыбораПоАлкогольнойПродукции = Истина;
//		Результат.ВозможнаЗагрузкаТСД                            = Истина;
//		Результат.ЗапретитьАкцизныеМаркиDataMatrixБезСтатуса     = Ложь;
//		
//		Результат.КлючевыеРеквизиты.Добавить("КоличествоПоСправке1");
//		Результат.КлючевыеРеквизиты.Добавить("НомерТТН");
//		Результат.КлючевыеРеквизиты.Добавить("ДатаТТН");
//		Результат.КлючевыеРеквизиты.Добавить("ДатаРозлива");
//		Результат.КлючевыеРеквизиты.Добавить("НомерПодтвержденияЕГАИС");
//		Результат.КлючевыеРеквизиты.Добавить("ДатаПодтвержденияЕГАИС");
//		
//	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.АктСписанияЕГАИС") Тогда
//		
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
//		
//		Результат.КонтрольАкцизныхМарок                          = Истина;
//		Результат.Операция                                       = Форма.Объект.ВидДокумента;
//		Результат.ДокументОснование                              = Форма.Объект.ДокументОснование;
//		Результат.ДокументЕГАИС                                  = Форма.Объект.Ссылка;
//		Результат.ОперацияКонтроляАкцизныхМарок                  = "АктСписания";
//		Результат.ОрганизацияЕГАИС                               = Форма.Объект.ОрганизацияЕГАИС;
//		Результат.СоздаватьШтрихкодУпаковки                      = Форма.Объект.ВидДокумента <> ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктСписанияИзРегистра2");
//		Результат.ДанныеВыбораПоАлкогольнойПродукции             = Форма.ДанныеВыбораПоАлкогольнойПродукции;
//		Результат.ИспользуютсяДанныеВыбораПоАлкогольнойПродукции = Истина;
//		Результат.ВозможнаЗагрузкаТСД                            = Истина;
//		
//		Результат.КлючевыеРеквизиты.Добавить("Цена");
//		
//	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ВозвратИзРегистра2ЕГАИС") Тогда
//		
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
//		
//		Результат.КонтрольАкцизныхМарок         = Истина;
//		Результат.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ВозвратИзРегистра2");
//		Результат.ДокументОснование             = Форма.Объект.ДокументОснование;
//		Результат.ДокументЕГАИС                 = Форма.Объект.Ссылка;
//		Результат.ОперацияКонтроляАкцизныхМарок = "Продажа";
//		Результат.ОрганизацияЕГАИС              = Форма.Объект.ОрганизацияЕГАИС;
//		Результат.СоздаватьШтрихкодУпаковки     = Ложь;
//		
//	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ЗапросАкцизныхМарокЕГАИС") Тогда
//		
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.КПостановкеНаБаланс"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.НеПодтверждена"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВРезерве"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Отсутствует"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
//		
//		Результат.КонтрольАкцизныхМарок         = Истина;
//		Результат.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросАкцизныхМарок");
//		Результат.ДокументОснование             = Форма.Объект.ДокументОснование;
//		Результат.ДокументЕГАИС                 = Форма.Объект.Ссылка;
//		Результат.ОперацияКонтроляАкцизныхМарок = "Продажа";
//		Результат.ОрганизацияЕГАИС              = Форма.Объект.ОрганизацияЕГАИС;
//		Результат.СоздаватьШтрихкодУпаковки     = Ложь;
//		
//		Результат.КлючевыеРеквизиты.Добавить("ТипМарки");
//		Результат.КлючевыеРеквизиты.Добавить("СерияМарки");
//		Результат.КлючевыеРеквизиты.Добавить("НомерМарки");
//		Результат.КлючевыеРеквизиты.Добавить("КодАкцизнойМарки");
//		
//		// Отключен контроль справок 2 и номенклатуры
//		Результат.ВыполнятьКонтрольЗаполненияДляDataMatrix = Ложь;
//		
//	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ПередачаВРегистр2ЕГАИС") Тогда
//		
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
//		
//		Результат.КонтрольАкцизныхМарок         = Ложь;
//		Результат.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ПередачаВРегистр2");
//		Результат.ДокументОснование             = Форма.Объект.ДокументОснование;
//		Результат.ДокументЕГАИС                 = Форма.Объект.Ссылка;
//		Результат.ОперацияКонтроляАкцизныхМарок = "Продажа";
//		Результат.ОрганизацияЕГАИС              = Форма.Объект.ОрганизацияЕГАИС;
//		Результат.СоздаватьШтрихкодУпаковки     = Ложь;
//		
//	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ТТНВходящаяЕГАИС") Тогда
//		
//		Результат.ЗапретитьАкцизныеМаркиDataMatrixБезСтатуса = Ложь;
//		
//	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ТТНИсходящаяЕГАИС") Тогда
//		
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
//		
//		Результат.КонтрольАкцизныхМарок                          = Истина;
//		Результат.Операция                                       = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ТТН");
//		Результат.ДокументОснование                              = Форма.Объект.ДокументОснование;
//		Результат.ДокументЕГАИС                                  = Форма.Объект.Ссылка;
//		Результат.ОрганизацияЕГАИС                               = Форма.Объект.Грузоотправитель;
//		Результат.СоздаватьШтрихкодУпаковки                      = Истина;
//		Результат.ДанныеВыбораПоАлкогольнойПродукции             = Форма.ДанныеВыбораПоАлкогольнойПродукции;
//		Результат.ИспользуютсяДанныеВыбораПоАлкогольнойПродукции = Истина;
//		Результат.ВозможнаЗагрузкаТСД                            = Истина;
//		
//		Результат.КлючевыеРеквизиты.Добавить("Цена");
//		Результат.КлючевыеРеквизиты.Добавить("НомерПартии");
//		Результат.КлючевыеРеквизиты.Добавить("ИдентификаторУпаковки");
//		
//	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ЧекЕГАИСВозврат") Тогда
//		
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
//		
//		Результат.КонтрольАкцизныхМарок                          = Истина;
//		Результат.Операция                                       = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
//		Результат.ДокументОснование                              = Форма.Объект.ДокументОснование;
//		Результат.ДокументЕГАИС                                  = Форма.Объект.Ссылка;
//		Результат.ОперацияКонтроляАкцизныхМарок                  = "Возврат";
//		Результат.ОрганизацияЕГАИС                               = Форма.Объект.ОрганизацияЕГАИС;
//		Результат.СоздаватьШтрихкодУпаковки                      = Истина;
//		Результат.ДанныеВыбораПоАлкогольнойПродукции             = Форма.ДанныеВыбораПоАлкогольнойПродукции;
//		Результат.ИспользуютсяДанныеВыбораПоАлкогольнойПродукции = Истина;
//		Результат.ВозможнаЗагрузкаТСД                            = Истина;
//		
//		Результат.КлючевыеРеквизиты.Добавить("Цена");
//		Результат.КлючевыеРеквизиты.Добавить("Штрихкод");
//		
//	ИначеЕсли СтрНачинаетсяС(Форма.ИмяФормы, "Документ.ЧекЕГАИС") Тогда
//		
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
//		Результат.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
//		
//		Результат.КонтрольАкцизныхМарок                          = Истина;
//		Результат.Операция                                       = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
//		Результат.ДокументОснование                              = Форма.Объект.ДокументОснование;
//		Результат.ДокументЕГАИС                                  = Форма.Объект.Ссылка;
//		Результат.ОперацияКонтроляАкцизныхМарок                  = "Продажа";
//		Результат.ОрганизацияЕГАИС                               = Форма.Объект.ОрганизацияЕГАИС;
//		Результат.СоздаватьШтрихкодУпаковки                      = Истина;
//		Результат.ДанныеВыбораПоАлкогольнойПродукции             = Форма.ДанныеВыбораПоАлкогольнойПродукции;
//		Результат.ИспользуютсяДанныеВыбораПоАлкогольнойПродукции = Истина;
//		Результат.ВозможнаЗагрузкаТСД                            = Истина;
//		
//		Результат.КлючевыеРеквизиты.Добавить("Цена");
//		Результат.КлючевыеРеквизиты.Добавить("Штрихкод");
//		
//	Иначе
//		
//		АкцизныеМаркиЕГАИСКлиентСерверПереопределяемый.ЗаполнитьПараметрыСканированияАкцизныхМарок(Результат, Форма);
//		
//	КонецЕсли;
//	
//	Возврат Результат;
//	
//КонецФункции

//&НаСервере
//&Вместо("УправлениеВидимостьюСтраницФормы")
//Процедура КочетовУправлениеВидимостьюСтраницФормы()
//	// Вставить содержимое метода.
//	//ПродолжитьВызов();
//КонецПроцедуры









