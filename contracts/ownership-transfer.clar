;; Ownership Transfer Contract
;; Manages changes in vehicle ownership

(define-map transfers
  { id: uint }
  {
    vin: (string-ascii 17),
    seller: principal,
    buyer: principal,
    status: (string-ascii 10),
    price: uint
  }
)

(define-data-var last-id uint u0)

;; Create transfer request
(define-public (create-transfer
              (vin (string-ascii 17))
              (buyer principal)
              (price uint))
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    ;; Update transfer counter
    (var-set last-id new-id)

    ;; Create the transfer request
    (ok (map-set transfers
      { id: new-id }
      {
        vin: vin,
        seller: tx-sender,
        buyer: buyer,
        status: "pending",
        price: price
      }
    ))
  )
)

;; Accept transfer request
(define-public (accept-transfer (transfer-id uint))
  (let
    (
      (transfer (unwrap! (get-transfer transfer-id) (err u404)))
    )
    ;; Only the buyer can accept
    (asserts! (is-eq tx-sender (get buyer transfer)) (err u403))
    ;; Only pending transfers can be accepted
    (asserts! (is-eq (get status transfer) "pending") (err u400))

    ;; Update transfer status
    (ok (map-set transfers
      { id: transfer-id }
      (merge transfer { status: "completed" })
    ))
  )
)

;; Get transfer details
(define-read-only (get-transfer (id uint))
  (map-get? transfers { id: id })
)

;; Get total transfers count
(define-read-only (get-total-transfers)
  (var-get last-id)
)

