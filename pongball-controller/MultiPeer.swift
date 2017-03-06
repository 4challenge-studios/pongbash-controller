
import UIKit
import MultipeerConnectivity


protocol MultiPeerDelegate {
    func conectado(nome: String)
    func mudarCor(cor: String)
}

class MultiPeer: NSObject {
    
    var peer = MCPeerID.init(displayName: UIDevice.current.name)
    let serviceTypePadrao = "pong"
    var advertiser: MCNearbyServiceAdvertiser
    var displayNameMaster: String?
    
    var delegate: MultiPeerDelegate?
    
    override init() {
        
        advertiser = MCNearbyServiceAdvertiser.init(peer: peer, discoveryInfo: ["key":(UIDevice.current.identifierForVendor?.uuidString)!], serviceType: serviceTypePadrao)
        
        super.init()
        
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    
    }
    
    lazy var session: MCSession = {
        let sessao = MCSession.init(peer: self.peer)
        sessao.delegate = self
        return sessao
    }()
    
}

extension MultiPeer: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("recebi convite")
        
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) { }
}


extension MultiPeer: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        let cor = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        
        self.delegate?.mudarCor(cor: cor)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .connected:
            guard let _ = self.displayNameMaster else {
                self.displayNameMaster = peerID.displayName
                print("Conectou \(self.displayNameMaster)")
                self.delegate?.conectado(nome: self.displayNameMaster!)
                return
            }
            
            
        case .connecting:
            print("Conectando \(peerID.displayName)")
        case .notConnected:
            print("Desconectou \(peerID.displayName)")
        }
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
}


















