;; Vehicle Registration Contract
;; Records vehicle details and ownership

(define-map vehicles
  { vin: (string-ascii 17) }
  {
    make: (string-ascii 20),
    model: (string-ascii 20),
    year: uint,
    owner: principal,
    status: (string-ascii 10)
  }
)

;; Register a new vehicle
(define-public (register-vehicle
              (vin (string-ascii 17))
              (make (string-ascii 20))
              (model (string-ascii 20))
              (year uint))
  (begin
    ;; Check if vehicle already exists
    (asserts! (is-none (map-get? vehicles { vin: vin })) (err u1))

    ;; Register the vehicle
    (ok (map-set vehicles
      { vin: vin }
      {
        make: make,
        model: model,
        year: year,
        owner: tx-sender,
        status: "active"
      }
    ))
  )
)

;; Update vehicle status
(define-public (update-status (vin (string-ascii 17)) (status (string-ascii 10)))
  (let
    (
      (vehicle (unwrap! (get-vehicle vin) (err u404)))
    )
    ;; Only owner can update status
    (asserts! (is-eq tx-sender (get owner vehicle)) (err u403))

    ;; Update vehicle status
    (ok (map-set vehicles
      { vin: vin }
      (merge vehicle { status: status })
    ))
  )
)

;; Get vehicle details
(define-read-only (get-vehicle (vin (string-ascii 17)))
  (map-get? vehicles { vin: vin })
)

