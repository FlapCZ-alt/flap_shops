let isShowed = false
isSellShowed = false

$(document).keyup(function(e) {
	if (e.key === "Escape") {
	  $.post('http://flap_shops/close', JSON.stringify({}));
    }
});

$(document).ready(function() {
	window.addEventListener('message', function(event) {
		var item = event.data;
		if (item.flap_mainMenu == true) {
            $('.ShopMainMenu').css('display', 'block');
		} else if (item.flap_SuccCloseBuyMenu == true) {
			succBuy(item.item, item.price)
		} else if (item.flap_SuccCloseSellMenu == true) {
			succSell(item.item, item.price, item.count)
		} else if (item.flap_WeigErrorCloseBuyMenu == true) {
			ErrorWeightBuy(item.item, item.price)

		} else if (item.flap_itemCountError == true) {
			itemCountError(item.item, item.price, item.count)


		} else if (item.flap_MoneyErrorCloseBuyMenu == true) {
			ErrorMoneyBuy(item.item, item.price)
        } else if (item.flap_mainMenu == false) {
            $('.ShopMainMenu').css('display', 'none');
			$('.ItemsContainer').css('display', 'none');
			$('.ItemsSellContainer').css('display', 'none');
			document.getElementsByClassName("popup")[0].classList.remove("active");
			document.getElementsByClassName("popup_buyMenu")[0].classList.remove("active");
			document.getElementsByClassName("popup_succBuy")[0].classList.remove("active");
			isShowed = false
			isSellShowed = false
        }

		if (item.label !== undefined) {
			$(".courseItemsContainer").append(`
			<div class="course">
				<div class="preview">
					<h2>`+item.label+`</h2>
					<h6>Price : $`+item.price+`</h6>
					<h6>Usable : `+item.usable+`</h6>
				</div>
				<div class="info">
					<h2>`+item.header+`</h2>
					<h6>`+item.description+`</h6>
					<button class="btn" onclick="openBuyMenu('`+item.item+`', '`+item.label+`', '`+item.price+`')">Buy</button>
				</div>
			</div>
			`);
		}

		if (item.label !== undefined) {
			$(".courseItemsSellContainer").append(`
			<div class="course">
				<div class="preview">
					<h2>`+item.label+`</h2>
					<h6>Earn : $`+item.earn+`</h6>
				</div>
				<div class="info">
					<h2>`+item.header+`</h2>
					<h6>`+item.description+`</h6>
					<button class="btn" onclick="openSellMenu('`+item.item+`', '`+item.label+`', '`+item.earn+`')">Sell</button>
				</div>
			</div>
			`);
		}

	});

    $(".choose_1").click(function() {
		if (!isShowed) {
			if (!isSellShowed) {
				isShowed = true
				$.post('http://flap_shops/GetShopItems', JSON.stringify({}));
				openItemsContainer()
			} else {
				document.getElementsByClassName("popup")[0].classList.add("active");
				$('.description').text('You must close the sales category first')
			}
		} else {
		    isShowed = false
			closeItemsContainer()
		}
    });

    $(".choose_2").click(function() {
		if (!isSellShowed) {
			if (!isShowed) {
				isSellShowed = true
				$.post('http://flap_shops/GetSellItems', JSON.stringify({}));
				openItemsSellContainer()
			} else {
				document.getElementsByClassName("popup")[0].classList.add("active");
				$('.description').text('You must close the purchase category first')
			}
		} else {
		    isSellShowed = false
			closeItemsSellContainer()
		}
    });

	$("#accept_wit").click(function() {
		$.post('http://flap_shops/GetShopItems', JSON.stringify({}));
    });

	$("#accept_sell").click(function() {
		$.post('http://flap_shops/GetSellItems', JSON.stringify({}));
    });
})

function openItemsContainer() {
	$('.course').remove();
	$('.ItemsContainer').css('display', 'block');
}

function closeItemsContainer() {
	$('.ItemsContainer').css('display', 'none');
}

function openItemsSellContainer() {
	$('.course').remove();
	$('.ItemsSellContainer').css('display', 'block');
}

function closeItemsSellContainer() {
	$('.ItemsSellContainer').css('display', 'none');
}

function closeBuyMenu() {
	document.getElementsByClassName("popup_buyMenu")[0].classList.remove("active");
}

function succBuy(item, price) {
	document.getElementsByClassName("popup_buyMenu")[0].classList.remove("active");

	$('.description').text("You spent $" + price + " to buy " + item)
	document.getElementsByClassName("popup_succBuy")[0].classList.add("active");
}

function succSell(item, price, count) {
	document.getElementsByClassName("popup_buyMenu")[0].classList.remove("active");

	$('.description').text("You sell " + count + "x " + item + " for $" + price)
	document.getElementsByClassName("popup_succBuy")[0].classList.add("active");
}

function ErrorWeightBuy() {
	document.getElementsByClassName("popup_buyMenu")[0].classList.remove("active");

	$('.description').text("You have no more space")
	document.getElementsByClassName("popup")[0].classList.add("active");
}

function itemCountError(item, price, count) {
	document.getElementsByClassName("popup_buyMenu")[0].classList.remove("active");

	$('.description').text("You don't have " + count + "x " + item)
	document.getElementsByClassName("popup")[0].classList.add("active");
}

function ErrorMoneyBuy() {
	document.getElementsByClassName("popup_buyMenu")[0].classList.remove("active");

	$('.description').text("You don't have enough money")
	document.getElementsByClassName("popup")[0].classList.add("active");
}

function itemsBuyed(item, price) {
	let inputValue = $(".inputWithMoney").val()
	if (!inputValue) {
		$.post("http://flap_shops/Notification", JSON.stringify({
			text: "you can not buy 0 pieces"
		}))
		return
	}
	$.post('http://flap_shops/buyItems', JSON.stringify({
		item: item,
		price: price,
		count: inputValue
	}));
}

function itemsSell(item, earn) {
	let inputValue = $(".inputWithMoney").val()
	if (!inputValue) {
		$.post("http://flap_shops/Notification", JSON.stringify({
			text: "you can not sell 0 pieces"
		}))
		return
	}
	$.post('http://flap_shops/sellItems', JSON.stringify({
		item: item,
		earn: earn,
		count: inputValue
	}));
}

function openBuyMenu(item, label, price) {
	document.getElementsByClassName("popup_buyMenu")[0].classList.add("active");
	$('.neco').remove();
	$(".popup_buyMenu").append(`
	    <div class="neco">
           <div class="icon">
                <i class="fas fa-store-alt"></i>
            </div>
            <div class="titleCustom">
            </div>
            <div class="titlePrice" id="test">
            </div>

            <input placeholder="amount" type="number" id="info-button" name="quantity" class="inputWithMoney" min="0" max="100" step="1">
            
            <div class="buttons">
            <div class="accept-btn">
                <button id="accept_wit" onclick="itemsBuyed('`+item+`', '`+price+`')">
                    confirm
                </button>
            </div>
            <div class="dismiss-btn">
                <button id="dismiss-popup2-btn" onclick="closeBuyMenu()">
                    cancel
                </button>
            </div>
            </div>
		</div>
	`);
	$('.titleCustom').text(label)
	$('.titlePrice').text("Price per piece - $" + price)
}

function openSellMenu(item, label, earn) {
	document.getElementsByClassName("popup_buyMenu")[0].classList.add("active");
	$('.neco').remove();
	$(".popup_buyMenu").append(`
	    <div class="neco">
           <div class="icon">
		        <i class="fas fa-tags"></i>
            </div>
            <div class="titleCustom">
            </div>
            <div class="titlePrice" id="test">
            </div>

            <input placeholder="amount" type="number" id="info-button" name="quantity" class="inputWithMoney" min="0" max="100" step="1">
            
            <div class="buttons">
            <div class="accept-btn">
                <button id="accept_sell" onclick="itemsSell('`+item+`', '`+earn+`')">
                    confirm
                </button>
            </div>
            <div class="dismiss-btn">
                <button id="dismiss-popup2-btn" onclick="closeBuyMenu()">
                    cancel
                </button>
            </div>
            </div>
		</div>
	`);
	$('.titleCustom').text(label)
	$('.titlePrice').text("Earn per piece - $" + earn)
}

document.getElementById("dismiss-popup-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup")[0].classList.remove("active");
});

document.getElementById("dismiss-popup3-btn").addEventListener("click",function(){
    document.getElementsByClassName("popup_succBuy")[0].classList.remove("active");
});