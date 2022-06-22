function padTo2Digits(num) {
    return num.toString().padStart(2, '0');
}

function convertMsToTime(milliseconds) {
    let seconds = Math.floor(milliseconds / 1000);
    let minutes = Math.floor(seconds / 60);
    let hours = Math.floor(minutes / 60);

    seconds = seconds % 60;
    minutes = minutes % 60;

    hours = hours % 24;

    return `${padTo2Digits(hours)}:${padTo2Digits(minutes)}:${padTo2Digits(
    seconds,
)}`;
}

const ul = document.getElementById('blocks');
const list = document.createDocumentFragment();
const url = 'http://192.168.0.17:3000/api/lastest-blocks';

fetch(url)
    .then((response) => {
        return response.json();
    })
    .then((data) => {
        let blocks = data;

        blocks.map(function(block) {
            let li = document.createElement('li');
            li.setAttribute('onclick','openTransaction(block.data)')
            let box = document.createElement('div');
            box.setAttribute('id', 'box');
            let chain_image = document.createElement('img');
            chain_image.setAttribute('src', './chain.png');
            box.appendChild(chain_image);
            li.appendChild(box)

            let info = document.createElement('div');
            info.setAttribute('id', 'general-info');
            let div1 = document.createElement('div');
            let hash_number = document.createElement('h3');
            hash_number.textContent = block.timestamp
            let div2 = document.createElement('div')
            let time = document.createElement('h4');
            let milliseconds = block.timestamp
            let current_time = Date.now()
            console.log(current_time)
            subtract = (new Date() - new Date(milliseconds));
            let time_reduce = (current_time - milliseconds)
            time.textContent = convertMsToTime(time_reduce) + "   ago"

            div1.appendChild(hash_number)
            div2.appendChild(time)
            info.appendChild(div1)
            info.appendChild(div2)
            li.appendChild(info)

            let hash = document.createElement('div')
            hash.setAttribute('id', 'hash')
            let current_hash = document.createElement('div')
            current_hash.setAttribute('id', 'current-hash')
            let current_text = document.createElement('div')
            current_text.setAttribute('id', 'current-text')
            let current_text_value = document.createElement('h3')
            current_text_value.textContent = "Block Hash"
            let current_value_section = document.createElement('div')
            current_value_section.setAttribute('id', 'current-hash-value')
            let current_value = document.createElement('h3')
            current_value.textContent = block.hash

            current_value_section.appendChild(current_value)
            current_text.appendChild(current_text_value)
            current_text.appendChild(current_value_section)
            current_hash.appendChild(current_text)
            hash.appendChild(current_hash)

            let previous_hash = document.createElement('div')
            previous_hash.setAttribute('id', 'previous-hash')
            let previous_text_value = document.createElement('h4')
            previous_text_value.textContent = "Previous Block"
            let previous_value = document.createElement('h4')
            previous_value.textContent = block.lastHash

            previous_hash(previous_text_value)
            previous_hash(previous_value)
            hash.appendChild(previous_hash)

            li.appendChild(hash)

            list.appendChild(li);
            console.log(list)
            console.log(block.timestamp)
        });
        ul.appendChild(list);
    })




function closeTransaction() {
    document.getElementById("block-detailed-section").style.display = "none";
}

function openTransaction(hashData) {
    document.getElementById("block-detailed-section").style.display = "block";

    let block_number_selected = document.getElementById("block-number-of-selected")
    block_number_selected.textContent = "#"+ block.timestamp

    let hash_of_this_block = document.getElementById("hash-of-this-block")
    hash_of_this_block.textContent = block.hash

    let hash_of_previous_block = document.getElementById("hash-of-previous-block")
    hash_of_previous_block.textContent = block.lastHash

    const ul2 = document.getElementById('detailed-transaction-block');
    const list2 = document.createDocumentFragment();


    hashData.data.map(function(transaction) {
        
    })
}