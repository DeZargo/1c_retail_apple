﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураОснования = Новый Структура;
	СтруктураОснования.Вставить("ТипРассылки", ПредопределенноеЗначение("Перечисление.ТипыИнформационныхРассылок.SMS"));
	СтруктураОснования.Вставить("ДокументОснование", ПараметрКоманды);
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", СтруктураОснования);
	ОткрытьФорму("Документ.ИнформационнаяРассылка.Форма.ФормаДокумента", СтруктураПараметры);
	
КонецПроцедуры

#КонецОбласти
