import argparse
import csv
import re
from tabulate import tabulate


# file_path = 'D:\DE\project_av\cars-av-by_card.csv'


def get_argpars() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument('--year_from', type=int, help='Год выпуска с', default=1900)
    parser.add_argument('--year_to', type=int, help='Год выпуска по', default=2023)
    parser.add_argument('--brand', type=str, help='Марка машины ', default='')
    parser.add_argument('--model', type=str, help='Модель машины', default='')
    parser.add_argument('--price_from', type=int, help='Год выпуска с', default='0')
    parser.add_argument('--price_to', type=int, help='Год выпуска по', default=None)
    parser.add_argument('--transmission', type=str, help='Тип коробки передач', default='')
    parser.add_argument('--milage', type=int, help='Максимальный пробег', default=None)
    parser.add_argument('--engine_from', type=int, help='Объём двигателя с', default=0)
    parser.add_argument('--engine_to', type=int, help='Объём двигателя по', default=None)
    parser.add_argument('--fuel', type=str, help='Тип топлива', default='')
    parser.add_argument('--exchange', type=str, help='Готовность совершить обмен', default='')
    parser.add_argument('--keywords', type=str, help='Ключевое слово', default='')
    parser.add_argument('--max_records', type=int, help='Количество объявлений', default=1000)
    return parser.parse_args()


# If brand have two or more words in name we use this table
brand_not_one_word = {
    "Land": "Land Rover",
    "Alfa": "Alfa Romeo",
    "Great": "Great Wall",
    "Iran": "Iran Khodro",
    "Lada": "Lada (ВАЗ)",
}


def get_brand(csvfile):
    extr_brand = csvfile.split(" ", maxsplit=2)[1]
    if extr_brand in brand_not_one_word:
        extr_brand = brand_not_one_word[extr_brand]
    return extr_brand.strip()


def get_model(csvfile, brand):
    prefix = "Продажа " + brand
    extr_model = csvfile.removeprefix(prefix)
    extr_model = extr_model.rsplit(",", maxsplit=2)[0]
    return extr_model.strip()


def get_price(csvfile):
    extr_price = "".join(ch for ch in csvfile if ch.isdigit())
    return int(extr_price)


def get_year(csvfile):
    extr_year = re.search(r"(\d{4}) г", csvfile).group(0)[:4]
    return int(extr_year)


def get_transmission(csvfile):
    extr_transmission = re.search(r"(\w+) привод", csvfile).group(0)
    return extr_transmission


def get_milage(csvfile):
    try:
        extr_milage = re.search(r".(\d+) км", csvfile).group(0)[:-3]
    except AttributeError:
        extr_milage = re.search(r".(\d+) км", csvfile)
    return int(extr_milage)


def get_engine(csvfile):
    try:
        extr_engine = re.search(r"(\d{1})([.,]\d+)? (\w),", csvfile).group(0)[:3]
    except AttributeError:
        extr_engine = re.search(r"(\d{1})([.,]\d+)? (\w),", csvfile)
    if extr_engine is None:
        extr_engine = '0'
    return extr_engine


def get_fuel(csvfile):
    try:
        extr_fuel = re.search(r"л, (\w+)", csvfile).group(0)[3:]
    except AttributeError:
        extr_fuel = re.search(r"л, (\w+)", csvfile)
    if extr_fuel is None:
        extr_fuel = 'электро'
    return extr_fuel


def get_agree_about_exchange(csvfile):
    try:
        extr_agree_about_exchange = re.search(r"(\w+).(\w+).(\w+)", csvfile).group(0)
    except AttributeError:
        extr_agree_about_exchange = re.search(r"(\w+).(\w+).(\w+)", csvfile)
    if extr_agree_about_exchange == 'Обмен не интересует':
        extr_agree_about_exchange = 'No'
    else:
        extr_agree_about_exchange = 'Yes'
    return extr_agree_about_exchange


def get_data_from_csv(path, max_records):
    with open(path, newline='', encoding='utf-8') as csvfile:
        readit = csv.DictReader(csvfile, delimiter=',')
        data = []
        for cnt, line in enumerate(readit):
            brand: str = get_brand(line["title"])
            model: str = get_model(line["title"], brand)
            price: int = get_price(line["price_secondary"])
            year: int = get_year(line["description"])
            transmission: str = get_transmission(line["description"])
            milage: int = get_milage(line["description"])
            engine: str = get_engine(line["description"])
            fuel: str = get_fuel(line["description"])
            exchange: str = get_agree_about_exchange(line["exchange"])
            card = ",".join(line.values())
            if cnt == max_records:
                break
            data.append(
                {"brand": brand, "model": model, "price": price, "year": year, "transmission": transmission,
                 "milage": milage,
                 "engine": engine, "fuel": fuel, "exchange": exchange, }
            )
        return data


def check_for_brand(input_data, condition_filtering: argparse.Namespace):
    if condition_filtering.brand is None:
        return True
    if input_data["brand"] == condition_filtering:
        return True
    return False


def check_for_model(input_data, condition_filtering: argparse.Namespace):
    if condition_filtering.model is None:
        return True
    if input_data["model"] == condition_filtering:
        return True
    return False


def check_for_price(input_data, condition_filtering: argparse.Namespace):
    if input_data["price"] >= condition_filtering.price_from:
        if input_data["price"] <= condition_filtering.price_to:
            return True
        else:
            return False
    return False


def check_for_year(input_data, condition_filtering: argparse.Namespace):
    if input_data["year"] >= condition_filtering.year_from:
        if input_data["year"] <= condition_filtering.year_to:
            return True
        else:
            return False
    return False


def check_for_transmission(input_data, condition_filtering: argparse.Namespace):
    if condition_filtering.transmission is None:
        return True
    if input_data["transmission"] == condition_filtering:
        return True
    return False


def check_for_engine(input_data, condition_filtering: argparse.Namespace):
    if input_data["engine"] >= condition_filtering.engine_from:
        if input_data["engine"] <= condition_filtering.engine_to:
            return True
        else:
            return False
    return False


def check_for_fuel(input_data, condition_filtering: argparse.Namespace):
    if condition_filtering.fuel is None:
        return True
    if input_data["fuel"] == condition_filtering:
        return True
    return False


def check_for_milage(input_data, condition_filtering: argparse.Namespace):
    if input_data["milage"] <= condition_filtering.milage:
        return True
    return False


def check_for_exchange(input_data, condition_filtering: argparse.Namespace):
    if condition_filtering.exchange is None:
        return True
    if input_data["exchange"] == condition_filtering:
        return True
    return False


def check_for_regexp(input_data, condition_filtering: argparse.Namespace):
    keyword = condition_filtering.keyword.split(",")
    for word in keyword:
        if word.strip() in input_data:
            return True
    return False


def order_data(data):
    data.sort(key=lambda line: (-line["price"], -line["year"], line["milage"]))


def show_data(data):
    return print(tabulate(data))


if __name__ == "__main__":
    args = get_argpars()
    input_data = get_data_from_csv("cars-av-by_card.csv", args.max_records)
    order_data(input_data)
    show_data(input_data)
