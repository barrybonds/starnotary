pragma solidity ^ 0.5.11;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721 {

    struct Star {
        string name;
    }

    string public name = "KendrickStar";
    string public symbol = "KST";

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    //Create Star using the Struct

    function createStar(string memory _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
    }

    //Putting a Str for Sale (Adding the stat tokenid into the mapping starsForSale, first verify that the sender is the owner)
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sell the Star you don't own");
        starsForSale[_tokenId] = _price;
    }

    //Function that allows you to convert an address into a payable adddres

    function _make_payable(address x) internal pure returns(address payable){
        return address(uint160(x));
    }

    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "You need to have enough Ether");

        _transferFrom(ownerAddress, msg.sender, _tokenId);
        address payable ownerAddressPayable = _make_payable(ownerAddress);
        ownerAddressPayable.transfer(starCost);
            if(msg.value > starCost){
                msg.sender.transfer(msg.value - starCost);
            }
        }

    function lookUptokenIdToStarInfo (uint _tokenId) public view returns (string memory) {
        return tokenIdToStarInfo[_tokenId].name;
    }


    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        address star1Owner = ownerOf(_tokenId1);
        address star2Owner = ownerOf(_tokenId2);

        require(msg.sender == star1Owner || msg.sender == star2Owner, "You don't own any of these stars!");

        _transferFrom(star1Owner, star2Owner, _tokenId1);
        _transferFrom(star2Owner, star1Owner, _tokenId2);
    }


    function transferStar(address _to1, uint256 _tokenId) public {
        address starOwner = ownerOf(_tokenId);
        require(msg.sender == starOwner, "You don't own this star!");

        _transferFrom(msg.sender, _to1, _tokenId);
    }


    }





