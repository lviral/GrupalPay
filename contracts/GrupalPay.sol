// solium-disable linebreak-style
pragma solidity ^0.4.23;

contract GrupalPay {

    //STRUCTS

    struct Issue {
        bytes32 title;
        uint totalAmount;
        uint currentAmount;
        address organizer;
        address recipient;
        bool closed;
        uint pointer;

        mapping(address => uint) payments;
    }

    //LISTS

    mapping(bytes32 => Issue) issuesStructs;
    bytes32[] issuesIds;

    mapping(address => uint) pendingWithdraws;


    //EXTERNAL FUNCTIONS

    ///@notice Create an Issue.
    ///@param Id The issue Id.
    ///@param title The issue title.
    ///@param amount The pay amount.
    ///@param recipient The payment beneficiary.
    ///@return True if success false if not.
    function createIssue(bytes32 id, bytes32 title, uint amount, address recipient) external returns(bool) {
        require(!isIssue(id), "This issue Id is already registred.");
        issuesStructs[id].title = title;
        issuesStructs[id].totalAmount = amount;
        issuesStructs[id].currentAmount = 0;
        issuesStructs[id].recipient = recipient;
        issuesStructs[id].closed = false;
        issuesStructs[id].pointer = issuesIds.push(id) - 1;

        return true;
    }

    ///@notice Send an individual pay to an issue.
    ///@param issueId The issue Id.
    ///@return True if success, false if not.
    function pay(bytes32 issueId) external payable returns (bool) {
        require(isIssue(issueId), "The Id isn't an issue.");
        issuesStructs[issueId].currentAmount += msg.value;
        issuesStructs[issueId].payments[msg.sender] += msg.value;

        if(totalAmountWasReached(issueId))
            closeIssue(issueId);

        return true;
    }

    //PRIVATE VIEW FUNCTIONS

    ///@notice Check if total amount was reached.
    ///@param issueId The isssue Id.
    ///@return True if total amount was reached, false if not.
    function totalAmountWasReached(bytes32 issueId) private view returns(bool) {
        return issuesStructs[issueId].currentAmount >= issuesStructs[issueId].currentAmount;
    }

    ///@notice Close an issue.
    ///@param issueId The issue Id.
    function closeIssue(bytes32 issueId) private {
        issuesStructs[issueId].closed = true;
    }

    ///@notice Check if is an issue.
    ///@param id The issue Id.
    ///@return True if is an issue false if not.
    function isIssue(bytes32 id) private view returns (bool) {
        if(issuesIds.length == 0) return false;
        return issuesIds[issuesStructs[id].pointer] == id;
    }

    function transferTotalAmount(bytes32 issueId) private {
        require(issuesStructs[issueId].closed, "The issue must be closed.");
        
    }
}