﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	СкрыватьПросмотренныеСерии = ПолучитьФункциональнуюОпцию("СкрыватьПросмотренныеСерии");		
	ЕстьВозможностьЗаполнятьПоКинопоиску = ПолучитьФункциональнуюОпцию("ИспользуетсяЗаполнениеИзКинопоискаПоАПИ");
	Элементы.ФормаЗаполнитьПоКинопоиску.Видимость = ЕстьВозможностьЗаполнятьПоКинопоиску;
	Элементы.ЗаполнитьСерииСезоныПоКинопоиску.Видимость = ЕстьВозможностьЗаполнятьПоКинопоиску;
	ВидимостьПоТипу();	
	ОбновитьСписокЗначенийЖанры();	
	ОбновитьСписокЗначенийСтраны();	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗначенийЖанры()	
	ТЗ = Объект.Жанры.Выгрузить();
	Жанры.ЗагрузитьЗначения(ТЗ.ВыгрузитьКолонку("Жанр"));
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗначенийСтраны()	
	ТЗ = Объект.Страны.Выгрузить();
	Страны.ЗагрузитьЗначения(ТЗ.ВыгрузитьКолонку("Страна"));
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСсылкуКинопоиск(Команда)
	Тип = ОпределитьСсылкуКинопоиск();
	Если НЕ Тип = "" Тогда
		ПерейтиПоНавигационнойСсылке("https://www.kinopoisk.ru/" + Тип + "/" + Объект.КодКинопоиск);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ОпределитьСсылкуКинопоиск()
	Если Объект.Тип = Перечисления.ТипыКино.Мультфильм ИЛИ Объект.Тип = Перечисления.ТипыКино.Фильм Тогда
		Тип = "film";
	ИначеЕсли Объект.Тип = Перечисления.ТипыКино.Сериал ИЛИ Объект.Тип = Перечисления.ТипыКино.Мультсериал Тогда
		Тип = "series";
	Иначе	
		Тип = "";
	КонецЕсли;
	Возврат Тип
КонецФункции

&НаСервере
Процедура ВидимостьПоТипу()
	Если Объект.Тип = Перечисления.ТипыКино.Сериал ИЛИ Объект.Тип = Перечисления.ТипыКино.Мультсериал Тогда
		Элементы.Год.Заголовок = "Год выпуска";
		Элементы.ГодОкончания.Видимость = Истина;
		Элементы.КоличествоСезонов.Видимость = Истина;
		Элементы.Группа6.Видимость = Истина;
		Элементы.ПоказатьПросмотренныеСерии.Видимость = СкрыватьПросмотренныеСерии;
	Иначе
		Элементы.Год.Заголовок = "Год";
		Элементы.ГодОкончания.Видимость = Ложь;
		Элементы.КоличествоСезонов.Видимость = Ложь; 
		Элементы.Группа6.Видимость = Ложь;
		Элементы.ПоказатьПросмотренныеСерии.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	ВидимостьПоТипу();
КонецПроцедуры

&НаСервере
Процедура ЖанрыПриИзмененииНаСервере()	
	Объект.Жанры.Очистить();
	Для каждого стр из Жанры Цикл
		Строка = Объект.Жанры.Добавить();
		Строка.Жанр = стр.Значение;
	КонецЦикла;
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЖанрыПриИзменении(Элемент)
	ЖанрыПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСерииПоСезону(Команда)
	Оповещение = Новый ОписаниеОповещения("ПослеВводаСезона", ЭтаФорма);	
	ПоказатьВводЧисла(Оповещение,,"Номер сезона",3,0);    	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаСезона(Результат, Параметры) Экспорт	
	Если Не Результат = Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеВводаКоличестваСерий", ЭтаФорма,Результат);
		ПоказатьВводЧисла(Оповещение,,"Количество серий",3,0);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаКоличестваСерий(Результат, Параметр) Экспорт	
	Если Не Результат = Неопределено Тогда
		Для Сч = 1 По Результат Цикл
			Серия = Объект.Серии.Добавить();
			Серия.Сезон = Параметр;
			Серия.Серия = Сч;	
		КонецЦикла; 
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьПросмотренные(Команда)
	ОбработатьПросмотрыСервер(Истина);
КонецПроцедуры

&НаСервере
Процедура ОбработатьПросмотрыСервер(Пометка)
	Для каждого Строка из Объект.Серии Цикл
		Если НЕ Строка.Просмотрена = Пометка Тогда 			
			Строка.Просмотрена = Пометка; 
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура УбратьПросмотренные(Команда)
	ОбработатьПросмотрыСервер(Ложь);
КонецПроцедуры

&НаСервере
Процедура СтраныПриИзмененииНаСервере()
	Объект.Страны.Очистить();
	Для каждого стр из Страны Цикл
		Строка = Объект.Страны.Добавить();
		Строка.Страна = стр.Значение;
	КонецЦикла;
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СтраныПриИзменении(Элемент)
	СтраныПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСсылкуIMDB(Команда)
	Если НЕ Объект.КодIMDB = "" Тогда
		ПерейтиПоНавигационнойСсылке("https://www.imdb.com/title/" + Объект.КодIMDB);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоКинопоиску(Команда)
	Если Объект.КодКинопоиск = "" Тогда
		Сообщить("Заполните код кинопоиска!");
	Иначе
		ПоказатьДлительнуюОперацию(Истина);
		Парам = Новый структура("Фильм,СезоныСерии",Истина,Ложь);
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьИзКинопоискаОповещение", ЭтаФорма,Парам);
    	ВыполнитьОбработкуОповещения(Оповещение,Неопределено); 		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзКинопоискаОповещение(Пусто, Парам) Экспорт 
	
	ЗаполнитьПоКинопоискуСервер(Парам.Фильм,Парам.СезоныСерии);
	Если НЕ Парам.СезоныСерии И ОпределитьСсылкуКинопоиск() = "series" Тогда
		ЗаполнитьПоКинопоискуСервер(Ложь,Истина);
	КонецЕсли;
	ВидимостьПоТипу();
	ЭтаФорма.Модифицированность = Истина;
	ПоказатьДлительнуюОперацию(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСерииСезоныПоКинопоиску(Команда)
	Если Объект.КодКинопоиск = "" Тогда
		Сообщить("Заполните код кинопоиска!");
	Иначе
		ПоказатьДлительнуюОперацию(Истина);
		Парам = Новый структура("Фильм,СезоныСерии",Ложь,Истина);
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьИзКинопоискаОповещение", ЭтаФорма,Парам);
    	ВыполнитьОбработкуОповещения(Оповещение,Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДлительнуюОперацию(Показать)
	
	Элементы.Группа8.Видимость = НЕ Показать;
	Элементы.ФормаЗаписатьИЗакрыть.Видимость = НЕ Показать;
	Элементы.ФормаЗаписать.Видимость = НЕ Показать;
	Элементы.ФормаУдалить.Видимость = НЕ Показать;
	Элементы.ФормаЗакрыть.Видимость = НЕ Показать;
	Элементы.ДлительнаяОперация.Видимость = Показать;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоКинопоискуСервер(Фильм,СезоныСерии)
	Если Фильм Тогда 
		kinopoisk_unofficial_api.ОбновитьФильмНаСервере(Объект);
		ОбновитьСписокЗначенийЖанры();	
		ОбновитьСписокЗначенийСтраны();
	КонецЕсли;
	Если СезоныСерии Тогда
		kinopoisk_unofficial_api.ОбновитьСезоныСерииНаСервере(Объект);
		СортировкаСерий();
	КонецЕсли;		
КонецПроцедуры   

&НаСервере
Процедура СортировкаСерий()
	Объект.Серии.Сортировать("Сезон,Серия");		
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПросмотренныеСерии(Команда)               	
	Элементы.ПоказатьПросмотренныеСерии.Пометка = Не Элементы.ПоказатьПросмотренныеСерии.Пометка; 	
	ПоказатьСкрытьСерии(Элементы.ПоказатьПросмотренныеСерии.Пометка);	
КонецПроцедуры  

&НаКлиенте
Процедура ПоказатьСкрытьСерии(Пометка)               	
	Если Пометка Тогда
		Элементы.Серии.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый структура());
	Иначе
		Элементы.Серии.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый структура("Просмотрена",Ложь));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПоказатьСкрытьСерии(НЕ СкрыватьПросмотренныеСерии);
КонецПроцедуры

