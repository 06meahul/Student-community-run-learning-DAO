module StudentLearningDAO::StudentDAO {
    use aptos_framework::signer;
    use std::vector;

    struct Topic has copy, drop, store { 
        title: vector<u8>,
        votes: u64,
    }

    struct DAO has key, store {
        topics: vector<Topic>,
    }

    public entry fun propose_topic(account: &signer, title: vector<u8>) acquires DAO {
        let dao = borrow_global_mut<DAO>(signer::address_of(account));
        let new_topic = Topic { title, votes: 0 };
        vector::push_back(&mut dao.topics, new_topic);
    }

    public entry fun vote_topic(account: &signer, index: u64) acquires DAO {
        let dao = borrow_global_mut<DAO>(signer::address_of(account));
        assert!(index < vector::length(&dao.topics), 1);
        let topic = &mut dao.topics[index];
        topic.votes = topic.votes + 1;
    }

    public entry fun init(account: &signer) {
        move_to(account, DAO { topics: vector::empty<Topic>() });
    }
}
