classdef ImageCipher
    properties
        Key
    end

    methods
        function obj = ImageCipher(key)
            obj.Key = key;
        end

        function encryptedImage = encrypt_image(obj, image)
            encryptedImage = obj.apply_xor(image);
        end

        function decryptedImage = decrypt_image(obj, image)
            decryptedImage = obj.apply_xor(image);
        end

        function resultImage = apply_xor(obj, image)
            encryptedImage = uint8(image);
            encryptedImage = bitxor(encryptedImage, bitand(obj.Key, 255));
            resultImage = encryptedImage;
        end
    end
end